import requests

url = "https://api.atmzphr.dev/?add"

payload = "{\n \"email\": \"someemail@email.com\",\n \"lan_ip\": \"123.123.123.123\",\n \"wan_ip\": \"123.123.123.123\",\n \"pub_key\": \"jklasdfj;asdfASdfAsdfjklasdfjkl;adfdf=\",\n \"end_point\": \"10.12.12.1:83484\"\n}"
headers = {
  'X-API-atmzphr-Key-x123-auth': 'thesuck-inoyrcice-iwyuvay-svikiypf-289ds',
  'Content-Type': 'application/json',
  'Cookie': '__cfduid=df424f29a72f1993d9611c9446f228e0e1596993939; datadome=-2WsfnMnLUwBdm3fmh.5eJ8mhJNQtWfSkotXsPXxO_kx9NfURUD5z~YoEn-aTTUqrED4l5PrAdAechuxrxb.g7OFeI3TVwP~qQzAk5g42.'
}

response = requests.request("POST", url, headers=headers, data = payload)

print(response.text.encode('utf8'))
