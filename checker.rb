require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'csv'
require 'open-uri'

BASE_URL = "http://ridetheclown.com/eveapi/audit.php?view=about"

data = CSV.read(ARGV[0], headers: true)

CSV.open('output.csv', 'wb') do |output|
  output << [
    "charname",
    "vcode",
    "apilink",
    "sp",
    "isk",
    "assets",
    "kblink",
    "kb",
    "status",
    "forumlink",
    "forum",
    "blacklist",
    "notes"
  ]

  data.each do |row|
    usid   = row[0]
    apikey = row[1]

    request_url = BASE_URL + "&usid=#{usid}&apik=#{apikey}"
    doc         = Nokogiri::HTML(open(request_url))


    charname = doc.css('div > span').first.text
    vcode = apikey
    apilink = request_url
    sp = doc.css('div > span')[1].css('b')[0].text
    isk = doc.css('div > span')[1].css('b')[1].text
    assets = ""
    kblink = "https://zkillboard.com/search/#{charname.gsub(' ', '+')}/"
    kb = ""
    status = ""
    forumlink = "https://forums.eveonline.com/default.aspx?g=search&postedby=#{charname.gsub(' ', '+')}"
    forum = ""
    blacklist = ""
    notes = ""

    formatted_row = [
      charname,
      vcode,
      apilink,
      sp,
      isk,
      assets,
      kblink,
      kb,
      status,
      forumlink,
      forum,
      blacklist,
      notes
    ]

    output << formatted_row
  end
end