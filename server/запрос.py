from flask import Flask
from data.users import User
from data.jobs import Jobs
from data.departments import Department
from data import db_session


app = Flask(__name__)
app.config['SECRET_KEY'] = 'yandexlyceum_secret_key'


def main():
    name_db = 'db/mars_explorer.db'  # input()
    db_session.global_init(name_db)
    db_sess = db_session.create_session()

    for department in db_sess.query(Department).all():
        print(department)


if __name__ == '__main__':
    main()
