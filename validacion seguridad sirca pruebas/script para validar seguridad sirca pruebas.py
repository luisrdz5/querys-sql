import mechanize
from bs4 import BeautifulSoup
import urllib2 
import cookielib

cj = cookielib.CookieJar()
br = mechanize.Browser()
br.set_handle_robots(False)
br.set_handle_equiv(False) 
br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]
br.set_cookiejar(cj)
br.open("http://http://10.55.210.38/sircanac_v4/index.php")

br.select_form(nr=0)
br.form['txtusuario'] = 'JDJRCRPU'
br.form['txtpassword'] = 'jose63122428.'
br.submit()

print br.response().read()






_______________________________________________







response = s.get(URL)
soup = BeautifulSoup(response.content,'html.parser')
print soup.b

form = soup.find('form')
fields = form.findAll('input')
formdata = dict( (field.get('name'), field.get('value')) for field in fields)

formdata['txtusuario'] = userString
formdata['txtpassword'] = passString

print formdata
posturl = urlparse.urljoin(URL, form['action'])
print posturl

r = s.post(posturl, data=posturl)
print r


#print s.get(URL).text