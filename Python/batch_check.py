from redirects import Redirect

testcheck = Redirect('http://www.searchengines.guru/showthread.php?t=843885',
                      'https://searchengines.guru/showthread.php?t=843885')
testcheck2 = Redirect('http://www.searchengines.guru/showthread.php?t=843885',
                       'http://searchengines.guru/showthread.php?t=843885')
testcheck3 = Redirect('http://ht.wingly.de/short-rsdbk-$1' )
testcheck.compare()
testcheck2.compare()
testcheck3.compare()

def plain_input(f1,f2):
    f1 = open(f1).read().splitlines()
    f2 = open(f2).read().splitlines()
    input_list = list(zip(f1, f2))
    objs = [Redirect(item[0],item[1]) for item in input_list]
    for obj in objs:
        Redirect.compare(obj)
plain_input('cleared_o_t.txt', 'cleared_n_t.txt')

# To be done
def csv_input(file):
    pass

Redirect.report()