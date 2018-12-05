from redirects import Redirect
import csv

# Custom methods to work with Redirect class. Get urls from CSV or from
# two different text files.


def plain_input(f1, f2, verbose=False):
    f1 = open(f1).read().splitlines()
    f2 = open(f2).read().splitlines()
    input_list = list(zip(f1, f2))
    objs = [Redirect(item[0], item[1]) for item in input_list]
    for obj in objs:
        Redirect.compare(obj, verbose)


def csv_input(file, verbose=False):
    csvfile = open(file).read().splitlines()
    table = csv.reader(csvfile, delimiter=";")
    objs = [Redirect(row[0], row[1]) for row in table if row[2] != 'Ignore']
    for obj in objs:
        Redirect.compare(obj, verbose)
        if not obj.new_url_match:
            print(obj.url)


plain_input('old_url_list.txt', 'target_url_list.txt')
csv_input('urls.csv', True)
Redirect.report()
