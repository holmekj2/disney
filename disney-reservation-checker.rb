require 'sinatra'
require 'time'
require_relative 'send-mail.rb'

set :bind, '0.0.0.0'

#Constants for API
LUNCH = 80000717
DINNER = 80000714
BREAKFAST = 80000712
$restaurants = {"BE_OUR_GUEST" => 16660079, 
    "CRYSTAL_PALACE" => 90002660, 
    "CINDERELLAS_ROYAL_TABLE" => 90002464,
    "CAPE_MAY" => 90001347,
    "BROWN_DERBY" => 90002245}

#reservation_date = "2019-03-28"
$notify_text = "3175083275@vtext.com"
$notify_email = 'holmekj2@gmail.com'
#$reservation_dates = ["2019-03-25", "2019-03-26", "2019-03-27", "2019-03-28"]
$reservation_dates = ["2019-10-05"]
if ARGV.length >= 1
    #Time can by "14:30", "LUNCH", "DINNER", "BREAKFAST"
    $reservation_dates = [ARGV[0]]
end

#$reservation_dates = ["2019-05-10"]
#$reservation_time = LUNCH
$reservation_time = "12:30"
if ARGV.length >= 2
    #Time can by "14:30", "LUNCH", "DINNER", "BREAKFAST"
    $reservation_time = ARGV[1]
end

$party_size = 5
$max_iterations = 1000
$restaurant_name = 'BE_OUR_GUEST'
if ARGV.length >= 3 
    $restaurant_name = ARGV[2]
end

$httpport = 4567
if ARGV.length >= 4
    $httpport = ARGV[3].to_i
end
set :port, $httpport 


$response = ""
$status = ""
$mycookie = "s_c24=1470166873720; s_vi=[CS]v1|2A72736C85012779-60000108C00007B1[CE]; LPVID=FjZWY1NWM3YmM3NjAzOGZm; UNID=e0c56014-41a4-438d-8433-4580e4aaf98b; _ga=GA1.2.118435497.1524620866; CRBLM_LAST_UPDATE=1524741094:{6E596593-3C9E-4F2A-8181-FEF27FA802F2}; WRUIDCD=1812040360345864; AMCV_EE0201AC512D2BE80A490D4C%40AdobeOrg=-1248264605%7CMCAID%7C2A72736C85012779-60000108C00007B1%7CMCMID%7C70726300526450400673623934523870625909%7CMCAAMLH-1536193459%7C7%7CMCAAMB-1536193459%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1535595859s%7CNONE; utag_main=_st:1535590572733$v_id:01600a67a7640014ea0cd54d44ca0507802220700093c$_sn:103$_ss:0$ses_id:1535588658682%3Bexp-session$_pn:1%3Bexp-session; _CT_RS_=Recording; _gac_UA-99867646-1=1.1544236102.CjwKCAiA0ajgBRA4EiwA9gFOR2f68lVxc3rv4mP0PT1eKqSmOqL_FGUcz0kAaeqqlwc_mlh2Hph0UBoCKmQQAvD_BwE; _gid=GA1.2.1740044973.1545516022; LPSID-65526753=_iNVCxTuRQyaN-o-d2pUlg; PHPSESSID=fn75m53li6m77ps3p6ip9d0735; GEOLOCATION_jar=%7B%22zipCode%22%3A%2246227%22%2C%22region%22%3A%22indiana%22%2C%22country%22%3A%22united+states%22%2C%22metro%22%3A%22indianapolis%22%2C%22metroCode%22%3A%22527%22%2C%22countryisocode%22%3A%22USA%22%7D; geolocation_aka_jar=%7B%22zipCode%22%3A%2246201-46209+46211+46214+46216-46231+46234-46237+46239-46242+46244+46247+46249-46251+46253-46256+46259-46260+46262+46266+46268+46274-46275+46277-46278+46280+46282-46283+46285+46290-46291+46295-46296+46298%22%2C%22region%22%3A%22IN%22%2C%22country%22%3A%22US%22%2C%22metro%22%3A%22INDIANAPOLIS%22%2C%22metroCode%22%3A%22527%22%7D; localeCookie_jar_aka=%7B%22contentLocale%22%3A%22en_US%22%2C%22version%22%3A%223%22%2C%22precedence%22%3A0%2C%22akamai%22%3A%22true%22%7D; languageSelection_jar_aka=%7B%22preferredLanguage%22%3A%22en_US%22%2C%22version%22%3A%221%22%2C%22precedence%22%3A0%2C%22language%22%3A%22en_US%22%2C%22akamai%22%3A%22true%22%7D; AMCVS_EDA101AC512D2B230A490D4C%40AdobeOrg=1; boomr_rt=r=https%3A%2F%2Fdisneyworld.disney.go.com%2Fdining%2Fmagic-kingdom%2Fbe-our-guest-restaurant%2F&ul=1545518176875&hd=1545518178688; mbox=PC#1486779081760-699757.28_77#1553294180|session#f98502b5c7834e738c8e4731fae30254#1545520040|mboxEdgeServer#mboxedge28.tt.omtrdc.net#1545520040|check#true#1545518240; AMCV_EDA101AC512D2B230A490D4C%40AdobeOrg=-330454231%7CMCAID%7C2A72736C85012779-60000108C00007B1%7CMCIDTS%7C17888%7CMCMID%7C77433228589582239494258159692534011387%7CMCAAMLH-1546122979%7C7%7CMCAAMB-1546122979%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCCIDH%7C1888634867%7CMCOPTOUT-1545525378s%7CNONE%7CvVersion%7C3.1.2; pep_oauth_token=a3c92b4b55b147debb21b0d3b8a24696; personalization_jar=%7B%22id%22%3A%22b8f65fd7-c5ba-4ee9-a152-e63403e44c09%22%7D; bkSent=true; LANGUAGE_MESSAGE_DISPLAY=3; surveyThreshold_jar=%7B%22pageViewThreshold%22%3A3%7D; UNID=e0c56014-41a4-438d-8433-4580e4aaf98b; _gat_gtag_UA_99867646_1=1; WDPROView=%7B%22version%22%3A2%2C%22preferred%22%3A%7B%22device%22%3A%22desktop%22%2C%22screenWidth%22%3A250%2C%22screenHeight%22%3A150%2C%22screenDensity%22%3A1.6000000238419%7D%2C%22deviceInfo%22%3A%7B%22device%22%3A%22desktop%22%2C%22screenWidth%22%3A250%2C%22screenHeight%22%3A150%2C%22screenDensity%22%3A1.6000000238419%7D%2C%22browserInfo%22%3A%7B%22agent%22%3A%22Chrome%22%2C%22version%22%3A%2270.0.3538.110%22%7D%7D; ADRUM_BT=R%3A49%7Cg%3A84f70717-37b5-4b8c-8708-670aacd08fe2295%7Cn%3ADisney-Prod_e4dfe7aa-6e26-4d68-9dc7-886d09949252%7Cd%3A93; _sdsat_enableClickTale=true; __CT_Data=gpv=543&apv_32300_www07=418&cpv_32300_www07=6&rpv_32300_www07=3&ckp=tld&dm=go.com&apv_6_www49=153&cpv_6_www49=152&rpv_6_www49=152; ClickTale-Lookup=325736193f453dfc3d01246a1700784a9122377f-1812040360345864-2055336541110690-6-fn75m53li6m77ps3p6ip9d0735falsefalse; ctm={\'pgv\':8847462268507068|\'vst\':4555528031483561|\'vstr\':3146634750887235|\'intr\':1545518188224|\'v\':1}; s_pers=%20s_c24%3D1469409026245%7C1564017026245%3B%20s_c20%3D1509561584810%7C1604169584810%3B%20s_fid%3D3CEC4A6364C01A87-22BC6C9CA26A4373%7C1601744604623%3B%20s_cpm%3D%255B%255B%2527KNC-FY19_WDW_TRA_DOM-EXCFL_W365_APH_4PK_Tickets-AP-Pass%25257CBR%25257CG%25257C4191013.WW.AM.01.01%25257CNA_NA_NA_NA_NA%2527%252C%25271544236101483%2527%255D%252C%255B%2527KNC-FY19_WDW_TRA_DOM-EXCFL_W365_APH_4PK_Tickets-AP-Pass%25257CBR%25257CG%25257C4191013.WW.AM.01.01%25257CNA_NA_NA_NA_NA%2527%252C%25271544236102204%2527%255D%252C%255B%2527KNC-FY19_WDW_TRA_DOM-EXCFL_W365_APH_4PK_Tickets-AP-Pass%25257CBR%25257CG%25257C4191013.WW.AM.01.01%25257CNA_NA_NA_NA_NA%2527%252C%25271544236122422%2527%255D%255D%7C1702002522422%3B%20s_gpv_pn%3Dwdpro%252Fwdw%252Fus%252Fen%252Ftools%252Ffinder%252Fdining%252Fmagickingdom%252Fbeourguestrestaurant%7C1545519991096%3B; s_sess=%20s_v4%3DD%253Dc7%3B%20s_cc%3Dtrue%3B%20s_tp%3D2684%3B%20s_ppv%3Dwdpro%252Fwdw%252Fus%252Fen%252Ftools%252Ffinder%252Fdining%252Fmagickingdom%252Fbeourguestrestaurant%252C47%252C47%252C1262%3B%20s_slt%3Dwdpro%252Fwdw%252Fus%252Fen%252Ftools%252Ffinder%252Fdining%252Fmagickingdom%252Fbeourguestrestaurant%255E%255EdineAvailSearchButton%255E%255Ewdpro%252Fwdw%252Fus%252Fen%252Ftools%252Ffinder%252Fdining%252Fmagickingdom%252Fbeourguestrestaurant%2520%257C%2520dineAvailSearchButton%255E%255EdiningReservationFormContainer%3B%20s_sq%3D%3B"
#puts request_curl
#system "#{request_curl}"
def search
    times_regex = /<span class="buttonText">(.*)<\/span>/
    loop_sleep_seconds = 60
    restaurant_id = $restaurants[$restaurant_name]
    puts "starting search for #{$restaurant_name} #{$reservation_dates}"
    iterations = 1
    while iterations <= $max_iterations
        if iterations > 1 
            puts "sleeping #{loop_sleep_seconds}"
            sleep loop_sleep_seconds
        end
        $reservation_dates.each do |rdate| 
            reservation_date = rdate
            #To get this curl string, go to Chrome and 
            # Log out of Disney and clear any cookies associated with Disney
            # Navigate to https://disneyworld.disney.go.com/dining/magic-kingdom/be-our-guest-restaurant/
            # Open developer tools and go to network tab
            # Click search times
            # Right click on dining-availbility in developer console and choose Copy->Copy as cURL
            # Can view form variables to get restaurant ids
            request_curl = "curl 'https://disneyworld.disney.go.com/finder/dining-availability/' -H $'cookie: #{$mycookie}' -H 'origin: https://disneyworld.disney.go.com' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'accept: */*' -H 'referer: https://disneyworld.disney.go.com/dining/magic-kingdom/be-our-guest-restaurant/' -H 'authority: disneyworld.disney.go.com' -H 'x-requested-with: XMLHttpRequest' -H 'x-cache-control: no-cache' --data 'pep_csrf=CkndZYt9PyFu35zFXTNS96D571Bnbzx6j4raQxHtv3TOe1lXA1a4Tu-AkRRoyPzROTmvO6h7da2WrW1XJQd1PB3MK1Ia9a7VYuwBpAB2nfMUAaXykiIownoUIcWCvpor&searchDate=#{reservation_date}&skipPricing=true&searchTime=#{$reservation_time}&partySize=#{$party_size}&id=#{restaurant_id}%3BentityType%3Drestaurant&type=dining' --compressed"        
            #Make the curl call
            puts request_curl
            $response = `#{request_curl}`
            #result = %x["#{request_curl}"]
            #puts response

            if $response.match(/data-hasavailability="1"/)
                #available_times = "available times"
                #puts response
                times_match = $response.scan(times_regex)
                available_times = times_match.to_s   
                #available_times = available_times[0]
                available_times = JSON.parse(available_times)
                puts "unfiltered times: #{available_times}"
                #If we are looking for a specific time then filter times outside of 
                #a half hour
                if $reservation_time != "LUNCH" and $reservation_time != "DINNER"
                    treservation_time = Time.parse($reservation_time)
                    available_times.select!{ |t| 
                        t0 = t[0]
                        at = Time.parse(t0)
                        #puts "at: #{at}"
                        # if treservation_time.hour > 12
                        #     at = at + 12 * 60 * 60
                        # end
                        delta_seconds = (at - treservation_time).abs 
                        delta_seconds <= 1800
                    }
                end
                if available_times.length > 0 
                    savailable_times = available_times.to_s
                    puts "filtered times: #{savailable_times}"
                    subject = "#{$restaurant_name} #{reservation_date}"
                    $status = subject + ":" + savailable_times
                    url = "http://99.32.162.56:#{$httpport}/response"
                    send_mail($notify_text, subject, savailable_times)
                    send_mail($notify_email, "#{subject}:#{savailable_times}", url)
                    #return 0
                end
            elsif $response.match(/data-hasavailability/)
                $status = "#{iterations}. #{reservation_date} not available"
                puts $status
                sleep 1
            else
                $status = "Invalid response...exiting"
                puts $status
                puts $response
                return 1
            end
        end
        iterations += 1
    end
end

get '/response' do
    $response
end

get '/status' do
    "#{$restaurant_name}: #{$reservation_dates}: #{$status}"
end

post '/start' do
    rsp = ""
    if $search_thread == nil
        #if pararms['restaurant']
        $search_thread = Thread.new{search()}
        rsp = "Started search"
    else
        rsp = "Search already running"
    end
    rsp
end

post '/stop' do
    if $search_thread != nil
        Thread.kill($search_thread)
        $search_thread = nil
    end
end

#puts "run this command to start search 'curl -X POST -i http://localhost:4567/start'"
$search_thread = Thread.new{search()}