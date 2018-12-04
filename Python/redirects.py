import requests
from time import time
from termcolor import colored

# Colored fail and pass msg template:

cpass = colored('Pass', 'green', attrs=['bold'])
cfail = colored('Fail', 'red', attrs=['bold'])

class Redirect:
    amount = 0
    failed = 0
    passed = 0
    def __init__(self, url, expected_url='', max_redirects=0):
        self.url = url
        self.expected_url = expected_url
        self.final_url = None
        self.final_response_code = None
        self.redirect_code = None
        self.redirect_history = None
        self.new_url_match = None
        self.last_check = None
        self.max_redirects = max_redirects
        Redirect.amount += 1

    @staticmethod
    def report():
        print(f'')
        print(f'Total redirects: {Redirect.amount}')
        print(f'Total {cfail}: {Redirect.failed}')
        print(f'Total {cpass}: {Redirect.passed}')

    def request(self):
        try:
            r = requests.get(self.url)
            self.final_url = r.url
            self.final_response_code = r.status_code
            self.redirect_history = r.history
        except requests.ConnectionError:
            return f'{cfail}: Connection problem with {self.url}!'
        except requests.TooManyRedirects:
            return f'{cfail}: Connection problem with {self.url}! Too many redirects! '

    def test(self):
        self.request()
        print(self.final_response_code, self.final_url)

    def history(self):
        try:
            for step in self.redirect_history:
                print(f'{step.status_code} {step.url}')
        except:
            pass

    def __verbose(self, status):
        print(f'Working on: {self.url}')
        if not status:
            if not self.expected_url:
                print(f'{cfail}: {self.final_response_code} Expected URL not set!')
                return
            else:
                print(f'{cfail}: {self.final_response_code} Expected: {self.expected_url} Received: {self.final_url}')
        else:
            print(f'{cpass}: {self.final_response_code} Expected: {self.expected_url} Received: {self.final_url}')
        self.history()


    def compare(self, verbose=True):
        if self.expected_url:
            self.request()
            self.last_check = time()
            if self.expected_url == self.final_url:
                Redirect.passed += 1
                self.new_url_match = True
                if verbose:
                    self.__verbose(True)
                return
            else:
                Redirect.failed += 1
                self.new_url_match = False
                if verbose:
                    self.__verbose(False)
                return
        else:
            Redirect.failed += 1
            if verbose:
                self.__verbose(False)
            return

