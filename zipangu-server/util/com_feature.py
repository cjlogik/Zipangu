from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import CountVectorizer
from konlpy.tag import Kkma
from konlpy.utils import pprint
import codecs
import cx_Oracle
import os
import re
import pandas as pd
from datetime import datetime
import numpy as np
from sklearn.metrics.pairwise import linear_kernel
import getpass

os.environ['NLS_LANG'] = '.UTF8'

f = open(r"D:\user\Desktop\testtest.txt", 'rb')
lines = f.read()
text = lines.decode(encoding='utf-8')

kkma = Kkma()
keyword = ' '.join(kkma.nouns(text))

def makeDictFactory(cursor):
    columnNames = [d[0] for d in cursor.description]

    def createRow(*args):
        return dict(zip(columnNames, args))

    return createRow

def OutputTypeHandler(cursor, name, defaultType, size, precision, scale):
    if defaultType == cx_Oracle.CLOB:
        return cursor.var(cx_Oracle.LONG_STRING, arraysize = cursor.arraysize)

conn = cx_Oracle.connect("hr/hr@localhost:1521/xe")
conn.outputtypehandler = OutputTypeHandler
conn.encoding
cursor = conn.cursor()
sql = "select * from company order by company_num"
cursor.execute(sql)
cursor.rowfactory = makeDictFactory(cursor)

rows = cursor.fetchall()

type_array = []
for data in rows:
    type_array.append(data['TYPE'])

type_array = list(set(type_array))

total_com = []
for type in type_array:
    temp = []
    for data in rows:
        if data['TYPE'] == type:
            temp.append(data['TEXT'])
    temp.insert(0,type)
    total_com.append(temp)

total_features = []
for array in total_com:
    feature = []
    feature.append(array[0])
    vectorize = CountVectorizer(min_df=0.1)
    X = vectorize.fit_transform(array)
    features = vectorize.get_feature_names()
    feature.append(features)
    total_features.append(feature)

def insert_com_features(total_result):
    sql = "insert into com_features(type_no, type, features) values(:type_no, :type, :features)"
    cursor.executemany(sql,total_result)
    conn.commit()

num = 0
total_result = []
while num <= 125:
    type_no = num + 1
    type = total_features[num][0]
    feature_arr = total_features[num][1]
    feature_str = ''
    for data in feature_arr:
        feature_str += data + ' '
    feature_tuple = (type_no,type,feature_str)
    total_result.append(feature_tuple)
    num += 1
