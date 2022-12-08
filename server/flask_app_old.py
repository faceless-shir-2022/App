from data import db_session
from data.fruktovaya_classrooms import Fruktovaya
from data.chongarskaya_classrooms import Chongarskaya
from data.krivorozhskaya_classrooms import Krivorozhskaya
from flask import Flask, render_template, request, send_file

app = Flask(__name__)
app.config['SECRET_KEY'] = 'yandexlyceum_secret_key'
name_db = 'classrooms.db'
db_session.global_init(f"/home/tortik13/mysite/db/{name_db}")

@app.route('/')
def hello():
    return 'Hello world'


@app.route("/fruktovaya/<from_cab>/<to_cab>", methods=['GET', 'POST'])
def navigator1(from_cab, to_cab):
    db_sess = db_session.create_session()
    point_a = db_sess.query(Fruktovaya).filter(Fruktovaya.name_or_number == from_cab).first()
    point_b = db_sess.query(Fruktovaya).filter(Fruktovaya.name_or_number == to_cab).first()
    if point_a.floor != point_b.floor:
        leader = nearest("fruktovaya", point_a.x_coordinate, point_a.y_coordinate)
    return f"""<head>
                <meta charset="utf-8">
                    <title>Ошибка</title>
                </head>
                <body>
                    <img src="/home/tortik13/mysite/static/img/fruktovaya_floor1.jfif" alt="лох">
                    <h2>go away... okay, you are going from {point_a.name_or_number} to {point_b.name_or_number}</h2>
                </body>"""


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
    leaders = {"fruktovaya": [[1, 1], [1, 1], [1, 1], [1, 1]],
               "chongarskaya": [[1, 1], [1, 1], [1, 1], [1, 1]],
               "krivorozhskaya": [[1, 1], [1, 1], [1, 1], [1, 1]]}
    print(leaders[school][0])
    return leaders[school][0]


def main():
    #name_db = 'classrooms.db'
    #db_session.global_init(f"/home/tortik13/mysite/db/{name_db}")
    app.run()


if __name__ == '__main__':
    main()

# http://127.0.0.1:5000/fruktovaya/104/107
