from data import db_session
from data.fruktovaya_classrooms import Fruktovaya
from data.chongarskaya_classrooms import Chongarskaya
from data.krivorozhskaya_classrooms import Krivorozhskaya
from flask import Flask
from PIL import Image, ImageDraw
from math import sqrt

app = Flask(__name__)
app.config['SECRET_KEY'] = 'yandexlyceum_secret_key'


@app.route("/fruktovaya/<from_cab>/<to_cab>", methods=['GET', 'POST'])
def navigator1(from_cab, to_cab):
    """
    Построение маршрутов. Здание по адресу Фруктовая ул., д.9

    Атрибуты
    --------
    from_cab : str
        название/номер пункта отправления (далее - пункта А)
    to_cab : str
        название/номер пункта назначения (далее - пункта В)
    x_choice, y_choice : list, list
        списки х и у координат поворотов
    xy_choice : list
        список координат поворотов (соотнесённых, в отличие от предыдущих двух списков)
    images : list
        список путей к картинкам с картами этажей здания школы на Фруктовой
    leader : list
        координаты ближайшей к пункту А лестницы
    leader1 : list
        координаты ближайшей к пункту В лестницы
    ax, ay, bx, by : int
        координаты х и у пунктов А и В соответственно
    final_way : list
        продуманный мною путь для отрисовки
    """

    from_cab, to_cab = from_cab.capitalize(), to_cab.capitalize()
    x_choice, y_choice = [170, 1110], [180, 865]
    xy_choice = [[170, 180], [1110, 180], [170, 865], [1110, 865]]
    images = ["static/img/fruktovaya_floor1.jfif",
              "static/img/fruktovaya_floor2.jfif",
              "static/img/fruktovaya_floor3.jfif"]
    db_sess = db_session.create_session()
    point_a = db_sess.query(Fruktovaya).filter(Fruktovaya.name_or_number == from_cab).first()
    point_b = db_sess.query(Fruktovaya).filter(Fruktovaya.name_or_number == to_cab).first()
    leader = nearest("fruktovaya", point_a.x_coordinate, point_a.y_coordinate)

    for image in images:

        if (str(point_a.floor) not in image[-11:]) and (str(point_b.floor) not in image[-11:]):
            """ Попадаем сюда, если картинка не будет задействована в построении маршрута, изменений нет """
            with Image.open(image) as im:
                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif (str(point_a.floor) in image[-11:]) and (str(point_b.floor) in image[-11:]):
            """ Попадаем сюда, если пункты А и В находятся на одном этаже """
            with Image.open(image) as im:
                draw = ImageDraw.Draw(im)
                ax, ay = point_a.x_coordinate, point_a.y_coordinate
                bx, by = point_b.x_coordinate, point_b.y_coordinate
                xdiff, ydiff = abs(ax - bx), abs(ay - by)

                coords = min_distance(ax, ay, xy_choice)

                if xdiff < abs(1053 - 225 - 2) and 150 <= ay <= 785 and 150 <= by <= 785:
                    """
                    Попадаем, если движемся вдоль вертикальных (относительно карты) стен, находящихся в одном коридоре
                    """
                    final_way = [(ax, ay), (coords[0], ay), (coords[0], by), (bx, by)]
                    draw.line(final_way, fill="RED", width=10)

                elif 1020 >= ax >= 240 and 1020 >= bx >= 240 and ydiff < abs(912 - 140):
                    """
                    Попадаем, если движемся вдоль горизонтальных (относительно карты) стен, находящихся в одном коридоре
                    """
                    final_way = [(ax, ay), (ax, coords[1]), (bx, coords[1]), (bx, by)]
                    draw.line(final_way, fill="RED", width=10)

                else:

                    if point_a.floor == 1:   # если находимся на первом этаже, то у нас особенные условия

                        leader1 = nearest("fruktovaya", bx, by)

                        if min_distance(ax, ay, [leader, [170, 865], [1110, 865]]) == leader and \
                                min_distance(bx, by, [leader1, [170, 865], [1110, 865]]) == leader1 and \
                                leader[0] == 180 and leader1[0] == 180:
                            """ Попадаем, если проще будет пройти через другой этаж, нежели обходить всю школу """
                            coords, coords1 = min_distance(ax, ay, xy_choice), min_distance(bx, by, xy_choice)

                            draw.line([(ax, ay), (coords[0], ay), (coords[0], coords[1]), (leader[0], leader[1])],
                                      fill="RED", width=10)
                            draw.line([(bx, by), (coords1[0], by), (coords1[0], coords1[1]), (leader1[0], leader1[1])],
                                      fill="RED", width=10)

                            with Image.open(images[1]) as im2:
                                draw = ImageDraw.Draw(im2)
                                draw.line([(leader[0], leader[1]), (leader1[0], leader1[1])], fill="RED", width=10)
                                image2 = images[1][:-5] + "(1).jfif"
                                im2.save(image2)
                            image2 = image[:-5] + "(1).jfif"
                            im.save(image2)
                            break

                        else:
                            """ Попадаем, если проще обойти по первому этажу (прогулки - тоже неплохо) """
                            [ax, ay], [bx, by] = sorted([[ax, ay], [bx, by]], key=lambda j: j[0])
                            coords, coords1 = [170, 865], [1110, 865]
                            final_way = [(ax, ay), (coords[0], ay), (coords[0], coords[1]), (coords1[0], coords1[1]),
                                         (coords1[0], by), (bx, by)]

                            draw.line(final_way, fill="RED", width=10)

                    else:   # если находимся на 2 или  этаже

                        if (ax <= 225 or ax >= 1053) and (bx <= 225 or bx >= 1053):
                            """ Попадаем, если путь от одной горизонтальной стены до другой горизонтальной стены """
                            coords1 = [x_choice[x_choice.index(coords[0]) - 1], coords[1]]
                            final_way = [(ax, ay), (coords[0], ay), (coords[0], coords[1]), (coords1[0], coords1[1]),
                                         (coords1[0], by), (bx, by)]
                        elif (ay <= 140 or ay >= 912) and (by <= 140 or by >= 912):
                            """ Попадаем, если добираемся от одной вертикальной стены до другой вертикальной стены """
                            coords1 = [coords[0], y_choice[y_choice.index(coords[1]) - 1]]
                            final_way = [(ax, ay), (ax, coords[1]), (coords[0], coords[1]), (coords1[0], coords1[1]),
                                         (bx, coords1[1]), (bx, by)]
                        else:
                            """ Попадаем при построении смешанного маршрута """
                            [ax, ay], [bx, by] = sorted([[ax, ay], [bx, by]], key=lambda j: j[0])
                            coords = min_distance((ax + bx) // 2, (ay + by) // 2, xy_choice)
                            if ax <= 225 or bx <= 225:   # если двигаемся от левого коридора
                                final_way = [(ax, ay), (coords[0], ay), (coords[0], coords[1]), (bx, coords[1]),
                                             (bx, by)]
                            else:   # если двигаемся от правого коридора
                                final_way = [(ax, ay), (ax, coords[1]), (coords[0], coords[1]), (coords[0], by),
                                             (bx, by)]
                        draw.line(final_way, fill="RED", width=10)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif str(point_a.floor) in image[-11:] and leader:
            """ Попадаем сюда, если обрабатываем картинку с этажом, на котором находится пункт А, ведём до лестницы """
            with Image.open(image) as im:
                draw = ImageDraw.Draw(im)
                x, y = point_a.x_coordinate, point_a.y_coordinate

                coords = min_distance(leader[0], leader[1], xy_choice)

                if x <= 225 or x >= 1053:   # если стартуем от вертикальных стен
                    final_way = [(x, y), (coords[0], y), (coords[0], coords[1]), (leader[0], coords[1]),
                                 (leader[0], leader[1])]
                else:   # если стартуем от горизонтальных стен
                    final_way = [(x, y), (x, leader[1]), (leader[0], leader[1])]
                draw.line(final_way, fill="RED", width=10)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif str(point_b.floor) in image[-11:] and leader:
            """ Попадаем сюда, если обрабатываем картинку с этажом, на котором находится пункт В, ведём от лестницы """
            with Image.open(image) as im:
                draw = ImageDraw.Draw(im)
                x, y = point_b.x_coordinate, point_b.y_coordinate

                coords = min_distance(leader[0], leader[1], xy_choice)
                print(coords)

                if y <= 140 or y >= 912:   # если старт от горизонтальных стен
                    if coords[1] == min_distance(x, y, xy_choice)[1]:
                        final_way = [(x, y), (x, leader[1]), (leader[0], leader[1])]
                    else:
                        coords1 = [coords[0], y_choice[y_choice.index(coords[1]) - 1]]
                        final_way = [(x, y), (x, coords1[1]), (coords1[0], coords1[1]), (coords1[0], leader[1]),
                                     (leader[0], leader[1])]
                else:   # если старт от вертикальных стен
                    if abs(leader[0] - x) > abs(1053 - 225):
                        coords1 = [x_choice[x_choice.index(coords[0]) - 1], coords[1]]
                        final_way = [(x, y), (coords1[0], y), (coords1[0], coords1[1]), (leader[0], leader[1])]
                    else:
                        final_way = [(x, y), (coords[0], y), (coords[0], coords[1]), (leader[0], leader[1])]
                draw.line(final_way, fill="RED", width=10)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

    return f"""<img src="/static/img/fruktovaya_floor1(1).jfif" alt="...">
                <img src="/static/img/fruktovaya_floor2(1).jfif" alt="...">
                <img src="/static/img/fruktovaya_floor3(1).jfif" alt="...">
                <h2>go away... okay, you are going from {point_a.name_or_number} to {point_b.name_or_number}</h2>"""


@app.route("/chongarskaya/<from_cab>/<to_cab>", methods=['GET', 'POST'])
def navigator2(from_cab, to_cab):
    db_sess = db_session.create_session()
    point_a = db_sess.query(Chongarskaya).filter(Chongarskaya.name_or_number == from_cab).first()
    point_b = db_sess.query(Chongarskaya).filter(Chongarskaya.name_or_number == to_cab).first()
    leader = nearest("chongarskaya", point_a.x_coordinate, point_a.y_coordinate)
    return f'go away... okay, you are going from {point_a.name_or_number} to {point_b.name_or_number} by {leader}'


@app.route("/krivorozhskaya/<from_cab>/<to_cab>", methods=['GET', 'POST'])
def navigator3(from_cab, to_cab):
    """
    Построение маршрутов. Здание по адресу Фруктовая ул., д.9

    Атрибуты
    --------
    from_cab : str
        название/номер пункта отправления (далее - пункта А)
    to_cab : str
        название/номер пункта назначения (далее - пункта В)
    xy_choice : list
        список координат поворотов
    images : list
        список путей к картинкам с картами этажей здания школы на Фруктовой
    exceptions : list
        исключения (кабинеты с особыми маршрутами)
    leader : list
        координаты ближайшей к пункту А лестницы
    ax, ay, bx, by : int
        координаты х и у пунктов А и В соответственно
    final_way : list
        продуманный мною путь для отрисовки
    """

    from_cab, to_cab = from_cab.capitalize(), to_cab.capitalize()
    xy_choice = [[220, 730], [640, 730], [1140, 730]]
    images = ["static/img/krivorozhskaya_floor1.jfif",
              "static/img/krivorozhskaya_floor2.jfif",
              "static/img/krivorozhskaya_floor3.jfif"]
    exceptions = ["Спортзал", "Актовый зал"]
    db_sess = db_session.create_session()
    point_a = db_sess.query(Krivorozhskaya).filter(Krivorozhskaya.name_or_number == from_cab).first()
    point_b = db_sess.query(Krivorozhskaya).filter(Krivorozhskaya.name_or_number == to_cab).first()
    leader = nearest("krivorozhskaya", point_a.x_coordinate, point_a.y_coordinate)

    for image in images:

        if (str(point_a.floor) not in image[-11:]) and (str(point_b.floor) not in image[-11:]):
            """ Попадаем сюда, если картинка не будет задействована в построении маршрута, изменений нет """
            with Image.open(image) as im:
                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif (str(point_a.floor) in image[-11:]) and (str(point_b.floor) in image[-11:]) and \
                (from_cab not in exceptions) and (to_cab not in exceptions):
            """ Попадаем сюда, если пункты А и В находятся на одном этаже и среди них нет исключений """
            with Image.open(image) as im:
                draw = ImageDraw.Draw(im)
                ax, ay = point_a.x_coordinate, point_a.y_coordinate
                bx, by = point_b.x_coordinate, point_b.y_coordinate

                final_way = [(ax, ay), (ax, xy_choice[1][1]), (bx, xy_choice[1][1]), (bx, by)]
                draw.line(final_way, fill="RED", width=8)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif str(point_a.floor) in image[-11:] and leader and \
                (from_cab not in exceptions) and (to_cab not in exceptions):
            """
            Попадаем сюда, если обрабатываем картинку с этажом, на котором находится пункт А, и ни один из пунктов не 
            является исключением, ведём до лестницы
            """
            with Image.open(image) as im:
                draw = ImageDraw.Draw(im)
                x, y = point_a.x_coordinate, point_a.y_coordinate

                final_way = [(x, y), (x, xy_choice[1][1]), (leader[0], xy_choice[1][1]), (leader[0], leader[1])]
                draw.line(final_way, fill="RED", width=8)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif str(point_b.floor) in image[-11:] and leader and \
                (from_cab not in exceptions) and (to_cab not in exceptions):
            """
            Попадаем сюда, если обрабатываем картинку с этажом, на котором находится пункт В, и ни один из пунктов не 
            является исключением, ведём от лестницы
            """
            with Image.open(image) as im:
                draw = ImageDraw.Draw(im)
                x, y = point_b.x_coordinate, point_b.y_coordinate

                final_way = [(x, y), (x, xy_choice[1][1]), (leader[0], xy_choice[1][1]), (leader[0], leader[1])]
                draw.line(final_way, fill="RED", width=8)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)
        else:
            """ Попадаем сюда, если один из пунктов является исключением """
            ax, ay = point_a.x_coordinate, point_a.y_coordinate
            bx, by = point_b.x_coordinate, point_b.y_coordinate

            if from_cab in exceptions and to_cab in exceptions:
                """ Попадаем, если оба пункта являются исключениями """
                with Image.open(images[point_a.floor - 1]) as im:
                    draw = ImageDraw.Draw(im)
                    final_way = [(ax, ay), (bx, by)]
                    draw.line(final_way, fill="RED", width=8)
                image2 = images[point_a.floor - 1][:-5] + "(1).jfif"
                im.save(image2)
                break

            else:
                """ Попадаем, если только один пункт является исключением, назначаем его пунктом А """
                floor_a, floor_b = point_a.floor, point_b.floor
                old = [[ax, ay], [bx, by]]
                [ax, ay], [bx, by] = sorted(old, key=lambda j: j[1])
                if [[ax, ay], [bx, by]] != old:
                    floor_a, floor_b = floor_b, floor_a
                leader = nearest("krivorozhskaya", bx, by)
                leader0 = [640, 50]

                if floor_b == floor_a:
                    """ Попадаем, если оба пункта находятся на 2 этаже """
                    with Image.open(images[floor_a - 1]) as im:
                        draw = ImageDraw.Draw(im)
                        final_way = [(bx, by), (bx, xy_choice[1][1]), (leader[0], xy_choice[1][1]),
                                     (leader[0], leader[1])]
                        draw.line(final_way, fill="RED", width=8)
                        final_way = [(ax, ay), (leader0[0], ay), (leader0[0], leader0[1])]
                        draw.line(final_way, fill="RED", width=8)
                    image2 = images[floor_a - 1][:-5] + "(1).jfif"
                    im.save(image2)

                    with Image.open(images[0]) as im:
                        draw = ImageDraw.Draw(im)
                        final_way = [(leader[0], leader[1]), (leader[0], xy_choice[1][1]),
                                     (leader0[0], xy_choice[1][1]), (leader0[0], leader0[1])]
                        draw.line(final_way, fill="RED", width=8)
                    image2 = images[0][:-5] + "(1).jfif"
                    im.save(image2)
                    break

                else:
                    """ Попадаем во всех остальных случаях """
                    leader = nearest("krivorozhskaya", bx, by)
                    leader0 = [640, 50]

                    with Image.open(images[floor_a - 1]) as im:
                        draw = ImageDraw.Draw(im)
                        final_way = [(ax, ay), (leader0[0], ay), (leader0[0], leader0[1])]
                        draw.line(final_way, fill="RED", width=8)
                    image2 = images[floor_a - 1][:-5] + "(1).jfif"
                    im.save(image2)

                    if floor_b == 1:
                        """ Попадаем, если пункт В находится на 1 этаже """
                        with Image.open(images[0]) as im:
                            draw = ImageDraw.Draw(im)
                            final_way = [(bx, by), (bx, xy_choice[1][1]), (leader0[0], xy_choice[1][1]),
                                         (leader0[0], leader0[1])]
                            draw.line(final_way, fill="RED", width=8)
                        image2 = images[0][:-5] + "(1).jfif"
                        im.save(image2)
                        break
                    else:
                        """ Попадаем, если пункт В находится на 3 этаже """
                        with Image.open(images[0]) as im:
                            draw = ImageDraw.Draw(im)
                            final_way = [(leader[0], leader[1]), (leader[0], xy_choice[1][1]),
                                         (leader0[0], xy_choice[1][1]), (leader0[0], leader0[1])]
                            draw.line(final_way, fill="RED", width=8)
                        image2 = images[0][:-5] + "(1).jfif"
                        im.save(image2)

                        with Image.open(images[floor_b - 1]) as im:
                            draw = ImageDraw.Draw(im)
                            final_way = [(bx, by), (bx, xy_choice[1][1]), (leader[0], xy_choice[1][1]),
                                         (leader[0], leader[1])]
                            draw.line(final_way, fill="RED", width=8)
                        image2 = images[floor_b - 1][:-5] + "(1).jfif"
                        im.save(image2)
                        break

    return f"""<img src="/static/img/krivorozhskaya_floor1(1).jfif" alt="...">
                <img src="/static/img/krivorozhskaya_floor2(1).jfif" alt="...">
                <img src="/static/img/krivorozhskaya_floor3(1).jfif" alt="...">
                <h2>go away... okay, you are going from {point_a.name_or_number} to {point_b.name_or_number}</h2>"""


def nearest(school, x, y):
    """
    Метод поиска ближайшей лестницы относительно заданных координат

    Атрибуты
    --------
    school : str
        название школы, в которой будем проводить поиск ближайшей лестницы
    x : int
        координата х точки
    y : int
        координата у точки
    leaders : dict
        словарь, в котором каждой школе соответствует список координат её лестниц

    :return : возвращает координаты ближайшей лестницы
    """
    leaders = {"fruktovaya": [[120, 180], [1160, 180], [120, 865], [1160, 865]],
               "chongarskaya": [[1, 1], [1, 1], [1, 1], [1, 1]],
               "krivorozhskaya": [[435, 707], [860, 707]]}
    minxdiff, minydiff = 2000, 2000
    choice = leaders[school]
    for x1, y1 in choice:
        minxdiff, minydiff = min(minxdiff, abs(x1 - x)), min(minydiff, abs(y1 - y))
    for x1, y1 in choice:
        if ((x1 == (x + minxdiff)) or (x1 == (x - minxdiff))) and ((y1 == (y + minydiff)) or (y1 == (y - minydiff))):
            leader = choice[choice.index([x1, y1])]
            return leader


def min_distance(x, y, iterable):
    """
    Метод поиска ближайшей точки из списка к заданной точке

    Атрибуты
    --------
    x : int
        координата х точки
    y : int
        координата у точки
    iterable : list
        список точек, из которых нужно выбрать ближайшую

    :return : возвращает координаты ближайшей точки
    """
    list_of_distances = list(map(lambda t: sqrt(pow(t[0] - x, 2) + pow(t[1] - y, 2)), iterable))
    min_res = min(list_of_distances)
    index_of_min = list_of_distances.index(min_res)
    return iterable[index_of_min]


def main():
    """ Функция запуска приложения """
    db_session.global_init("db/classrooms.db")
    name_db = 'classrooms.db'
    db_session.global_init(f"db/{name_db}")
    app.run()


if __name__ == '__main__':
    main()
