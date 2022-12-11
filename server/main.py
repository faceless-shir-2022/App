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
    leader = [0, 0]
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
            # если этаж не используется в маршруте
            with Image.open(image) as im:
                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif (str(point_a.floor) in image[-11:]) and (str(point_b.floor) in image[-11:]):
            with Image.open(image) as im:
                # если на одном этаже А и В
                draw = ImageDraw.Draw(im)
                ax, ay = point_a.x_coordinate, point_a.y_coordinate
                bx, by = point_b.x_coordinate, point_b.y_coordinate
                xdiff, ydiff = abs(ax - bx), abs(ay - by)

                coords = min_distance(ax, ay, xy_choice)

                if xdiff < abs(1053 - 225 - 2) and 150 <= ay <= 785 and 150 <= by <= 785:
                    final_way = [(ax, ay), (coords[0], ay), (coords[0], by), (bx, by)]
                    draw.line(final_way, fill="RED", width=10)
                    print("vertical", ax, ay, bx, by, coords, xdiff, abs(coords[0] - max(ax, bx) - 50))
                elif 1020 >= ax >= 240 and 1020 >= bx >= 240 and ydiff < abs(912 - 140):
                    final_way = [(ax, ay), (ax, coords[1]), (bx, coords[1]), (bx, by)]
                    draw.line(final_way, fill="RED", width=10)
                    print("horizontal")

                else:
                    print("hard way")
                    if point_a.floor == 1:
                        leader1 = nearest("fruktovaya", bx, by)
                        if min_distance(ax, ay, [leader, [170, 865], [1110, 865]]) == leader and \
                                min_distance(bx, by, [leader1, [170, 865], [1110, 865]]) == leader1:
                            coords, coords1 = min_distance(ax, ay, xy_choice), min_distance(bx, by, xy_choice)
                            draw.line([(ax, ay), (coords[0], ay), (coords[0], coords[1]), (leader[0], leader[1])], fill="RED", width=10)
                            draw.line([(bx, by), (coords1[0], by), (coords1[0], coords1[1]), (leader1[0], leader1[1])], fill="RED", width=10)
                            with Image.open(images[1]) as im2:
                                draw = ImageDraw.Draw(im2)
                                draw.line([(leader[0], leader[1]), (leader1[0], leader1[1])], fill="RED", width=10)
                                image2 = images[1][:-5] + "(1).jfif"
                                im2.save(image2)
                            image2 = image[:-5] + "(1).jfif"
                            im.save(image2)
                            break

                        else:
                            [ax, ay], [bx, by] = sorted([[ax, ay], [bx, by]], key=lambda j: j[0])
                            coords, coords1 = [170, 865], [1110, 865]
                            final_way = [(ax, ay), (coords[0], ay), (coords[0], coords[1]), (coords1[0], coords1[1]), (coords1[0], by), (bx, by)]
                            draw.line(final_way, fill="RED", width=10)

                    else:
                        if (ax <= 225 or ax >= 1053) and (bx <= 225 or bx >= 1053):
                            coords1 = [x_choice[x_choice.index(coords[0]) - 1], coords[1]]
                            print("1)", coords, coords1)
                            final_way = [(ax, ay), (coords[0], ay), (coords[0], coords[1]), (coords1[0], coords1[1]),
                                         (coords1[0], by), (bx, by)]
                        elif (ay <= 140 or ay >= 912) and (by <= 140 or by >= 912):
                            coords1 = [coords[0], y_choice[y_choice.index(coords[1]) - 1]]
                            print("2)", coords, coords1)
                            final_way = [(ax, ay), (ax, coords[1]), (coords[0], coords[1]), (coords1[0], coords1[1]),
                                         (bx, coords1[1]), (bx, by)]
                        else:
                            [ax, ay], [bx, by] = sorted([[ax, ay], [bx, by]], key=lambda j: j[0])
                            coords = min_distance((ax + bx) // 2, (ay + by) // 2, xy_choice)
                            print("3)", coords, (ax, ay), (bx, by))
                            if ax <= 225 or bx <= 225:
                                final_way = [(ax, ay), (coords[0], ay), (coords[0], coords[1]), (bx, coords[1]), (bx, by)]
                            else:
                                final_way = [(ax, ay), (ax, coords[1]), (coords[0], coords[1]), (coords[0], by), (bx, by)]
                        draw.line(final_way, fill="RED", width=10)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif str(point_a.floor) in image[-11:] and leader:
            print("from A to leader")
            with Image.open(image) as im:
                # довести от пункта А до лестницы
                draw = ImageDraw.Draw(im)
                x, y = point_a.x_coordinate, point_a.y_coordinate

                coords = min_distance(leader[0], leader[1], xy_choice)
                print(coords)

                if x <= 225 or x >= 1053:
                    final_way = [(x, y), (coords[0], y), (coords[0], coords[1]), (leader[0], coords[1]), (leader[0], leader[1])]
                else:
                    final_way = [(x, y), (x, leader[1]), (leader[0], leader[1])]
                draw.line(final_way, fill="RED", width=10)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)

        elif str(point_b.floor) in image[-11:] and leader:
            print("from leader to B")
            with Image.open(image) as im:
                # довести от лестницы до пункта В
                draw = ImageDraw.Draw(im)
                x, y = point_b.x_coordinate, point_b.y_coordinate

                coords = min_distance(leader[0], leader[1], xy_choice)
                print(coords)

                if y <= 140 or y >= 912:
                    print("ne simple")
                    if coords[1] == min_distance(x, y, xy_choice)[1]:
                        final_way = [(x, y), (x, leader[1]), (leader[0], leader[1])]
                    else:
                        coords1 = [coords[0], y_choice[y_choice.index(coords[1]) - 1]]
                        final_way = [(x, y), (x, coords1[1]), (coords1[0], coords1[1]), (coords1[0], leader[1]), (leader[0], leader[1])]
                else:
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
    if point_a.floor != point_b.floor:
        leader = nearest("chongarskaya", point_a.x_coordinate, point_a.y_coordinate)
    return f'go away... okay, you are going from {point_a.name_or_number} to {point_b.name_or_number}'


@app.route("/krivorozhskaya/<from_cab>/<to_cab>", methods=['GET', 'POST'])
def navigator3(from_cab, to_cab):
    db_sess = db_session.create_session()
    point_a = db_sess.query(Krivorozhskaya).filter(Krivorozhskaya.name_or_number == from_cab).first()
    point_b = db_sess.query(Krivorozhskaya).filter(Krivorozhskaya.name_or_number == to_cab).first()
    if point_a.floor != point_b.floor:
        leader = nearest("krivorozhskaya", point_a.x_coordinate, point_a.y_coordinate)
    return f'go away... okay, you are going from {point_a.name_or_number} to {point_b.name_or_number}'


def nearest(school, x, y):
    leaders = {"fruktovaya": [[120, 180], [1160, 180], [120, 865], [1160, 865]],
               "chongarskaya": [[1, 1], [1, 1], [1, 1], [1, 1]],
               "krivorozhskaya": [[1, 1], [1, 1], [1, 1], [1, 1]]}
    minxdiff, minydiff = 2000, 2000
    choice = leaders[school]
    for x1, y1 in choice:
        minxdiff, minydiff = min(minxdiff, abs(x1 - x)), min(minydiff, abs(y1 - y))
    for x1, y1 in choice:
        if ((x1 == (x + minxdiff)) or (x1 == (x - minxdiff))) and ((y1 == (y + minydiff)) or (y1 == (y - minydiff))):
            leader = choice[choice.index([x1, y1])]
            return leader


def min_distance(x, y, iterable):
    list_of_distances = list(map(lambda t: sqrt(pow(t[0] - x, 2) + pow(t[1] - y, 2)), iterable))
    min_res = min(list_of_distances)
    index_of_min = list_of_distances.index(min_res)
    return iterable[index_of_min]


def main():
    db_session.global_init("db/classrooms.db")
    name_db = 'classrooms.db'
    db_session.global_init(f"db/{name_db}")
    app.run()


if __name__ == '__main__':
    main()
