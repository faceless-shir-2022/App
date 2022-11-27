import sqlalchemy
from .db_session import SqlAlchemyBase


class Chongarskaya(SqlAlchemyBase):
    __tablename__ = 'chongarskaya_classrooms'

    name_or_number = sqlalchemy.Column(sqlalchemy.String, unique=True, primary_key=True)
    floor = sqlalchemy.Column(sqlalchemy.Integer)
    x_coordinate = sqlalchemy.Column(sqlalchemy.Integer)
    y_coordinate = sqlalchemy.Column(sqlalchemy.Integer)