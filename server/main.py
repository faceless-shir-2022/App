from data import db_session
from data.fruktovaya_classrooms import Fruktovaya
from data.chongarskaya_classrooms import Chongarskaya
from data.krivorozhskaya_classrooms import Krivorozhskaya
from flask import Flask, render_template, request
from PIL import Image, ImageDraw


app = Flask(__name__)
app.config['SECRET_KEY'] = 'yandexlyceum_secret_key'


@app.route("/fruktovaya/<from_cab>/<to_cab>", methods=['GET', 'POST'])
def navigator1(from_cab, to_cab):
    leader = [0, 0]
    x_choice, y_choice = [160, 1073], [170, 880]
    images = ["static/img/fruktovaya_floor1.jfif",
              "static/img/fruktovaya_floor2.jfif",
              "static/img/fruktovaya_floor3.jfif"]
    db_sess = db_session.create_session()
    point_a = db_sess.query(Fruktovaya).filter(Fruktovaya.name_or_number == from_cab).first()
    point_b = db_sess.query(Fruktovaya).filter(Fruktovaya.name_or_number == to_cab).first()
    if point_a.floor != point_b.floor:
        leader = nearest("fruktovaya", point_a.x_coordinate, point_a.y_coordinate)
    for image in images:
        if (str(point_a.floor) not in image) and (str(point_b.floor) not in image):
            with Image.open(image) as im:
                image2 = image[:-5] + "(1).jfif"
                im.save(image2)
        elif (str(point_a.floor) in image) and (str(point_b.floor) in image):
            with Image.open(image) as im:
                # если на одном этаже А и В
                image2 = image[:-5] + "(1).jfif"
                im.save(image2)
        elif str(point_a.floor) in image and leader:
            with Image.open(image) as im:
                # довести от пункта А до лестницы
                draw = ImageDraw.Draw(im)
                x, y = point_a.x_coordinate, point_a.y_coordinate
                minx, miny = 2000, 2000
                for x1 in x_choice:
                    for y1 in y_choice:
                        minx, miny = min(minx, abs(leader[0] - x1)), min(miny, abs(leader[1] - y1))
                print(x, y)
                for x1 in x_choice:
                    for y1 in y_choice:
                        if ((x1 == (leader[0] + minx)) or (x1 == (leader[0] - minx))) and \
                                ((y1 == (leader[1] + miny)) or (y1 == (leader[1] - miny))):
                            coords = [x1, y1]
                            print(coords)

                final_way = [(x, y), (coords[0], y), (coords[0], coords[1]), (leader[0], coords[1]), (leader[0], leader[1])]
                draw.line(final_way, fill="RED", width=10)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)
        elif str(point_b.floor) in image and leader:
            with Image.open(image) as im:
                # довести от лестницы до пункта В
                draw = ImageDraw.Draw(im)
                x, y = point_b.x_coordinate, point_b.y_coordinate
                minx, miny = 2000, 2000
                for x1 in x_choice:
                    for y1 in y_choice:
                        minx, miny = min(minx, abs(leader[0] - x1)), min(miny, abs(leader[1] - y1))
                print(x, y)
                for x1 in x_choice:
                    for y1 in y_choice:
                        if ((x1 == (leader[0] + minx)) or (x1 == (leader[0] - minx))) and \
                                ((y1 == (leader[1] + miny)) or (y1 == (leader[1] - miny))):
                            coords = [x1, y1]
                            print(coords)

                final_way = [(x, y), (coords[0], y), (coords[0], coords[1]), (leader[0], coords[1]), (leader[0], leader[1])]
                draw.line(final_way, fill="RED", width=10)

                image2 = image[:-5] + "(1).jfif"
                im.save(image2)
    return f"""<!doctype html>
                <html lang="en">
                    <head>
                        <meta charset="utf-8">
                        <title>Ошибка</title>
                    </head>
                    <body>
                        <img src="/static/img/fruktovaya_floor1(1).jfif" alt="...">
                        <img src="/static/img/fruktovaya_floor2(1).jfif" alt="...">
                        <img src="/static/img/fruktovaya_floor3(1).jfif" alt="...">
                        <h2>go away... okay, you are going from {point_a.name_or_number} to {point_b.name_or_number}</h2>
                        <h2>{leader}</h2>
                    </body>
                </html>"""
    # return f"go away... okay, you are going from {point_a.name_or_number} to {point_b.name_or_number}"


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
    leaders = {"fruktovaya": [[120, 180], [1160, 180], [120, 870], [1160, 870]],
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


def main():
    db_session.global_init("db/classrooms.db")
    name_db = 'classrooms.db'
    db_session.global_init(f"db/{name_db}")
    app.run()


if __name__ == '__main__':
    main()
