sub Init()
  m.top.ObserveField("wasShown", "OnWasShown")
end sub

sub OnWasShown()
  m.top.setFocus(true)

  m.audio_track_index = 1

  m.parks = []
  m.park_id_index = 0
  m.park_ids = [ "mk", "ep", "hs", "ak", "ds", "tl", "bb" ]

  m.light_font = CreateObject("roSGNode", "Font")
  m.light_font.uri = "pkg:/components/fonts/avenir_45_book_latin.ttf"
  m.light_font.size = 26

  setUpLabels()

  buildTasks()

  setUpTimers()

  setUpAudio()

  refreshData()
end sub

sub setUpLabels()
  m.park_image = m.top.findNode("park_image")
  m.name = m.top.findNode("name")
  m.todaysHours = m.top.findNode("todaysHours")

  m.day_of_the_week = m.top.findNode("day_of_the_week")
  m.day_of_the_week.font = m.light_font

  m.month_day = m.top.findNode("month_day")
  m.month_day.font = m.light_font

  m.time = m.top.findNode("time")

  m.weather = m.top.findNode("weather")
  m.weather.font = m.light_font

  m.mk_hours = m.top.findNode("mk_hours")
  m.mk_hours.font = m.light_font
  m.ep_hours = m.top.findNode("ep_hours")
  m.ep_hours.font = m.light_font
  m.hs_hours = m.top.findNode("hs_hours")
  m.hs_hours.font = m.light_font
  m.ak_hours = m.top.findNode("ak_hours")
  m.ak_hours.font = m.light_font
  m.ds_hours = m.top.findNode("ds_hours")
  m.ds_hours.font = m.light_font
  m.tl_hours = m.top.findNode("tl_hours")
  m.tl_hours.font = m.light_font
  m.bb_hours = m.top.findNode("bb_hours")
  m.bb_hours.font = m.light_font
end sub

sub buildTasks()
  m.TodayParkHoursTask = CreateObject("roSGNode", "TodayParkHoursTask")
  m.TodayParkHoursTask.ObserveField("parks", "onParksChanged")

  m.WeatherTask = CreateObject("roSGNode", "WeatherTask")
  m.WeatherTask.ObserveField("weather_info", "onWeatherChanged")

  m.DateTimeTask = CreateObject("roSGNode", "DateTimeTask")
  m.DateTimeTask.ObserveField("datetime_info", "onDateTimeChanged")
end sub

sub setUpTimers()
  m.changepark_timer = m.top.findNode("changepark_timer")
  m.changepark_timer.control = "start"
  m.changepark_timer.ObserveField("fire", "changePark")

  m.updatetime_timer = m.top.findNode("updatetime_timer")
  m.updatetime_timer.control = "start"
  m.updatetime_timer.ObserveField("fire", "updateDateTime")
end sub

sub setUpAudio()
  m.audio = m.top.findNode("audio_player")
  m.audio.observeField("state", "audioPlayerStateChanged")

  changeAudioTrack()
end sub

sub refreshData()
  m.TodayParkHoursTask.control = "RUN"
  m.WeatherTask.control = "RUN"
  m.DateTimeTask.control = "RUN"
end sub

sub changePark()
  m.park_id_index++

  if (m.park_id_index > 6) then m.park_id_index = 0

  updatePark()
end sub

sub updatePark()
  current_park_id = m.park_ids[m.park_id_index]
  m.current_park = m.parks[current_park_id]
  m.park_image.uri = m.current_park.imageUrl
  m.name.text = m.current_park.name
  m.todaysHours.text = m.current_park.todaysHours
end sub

sub updateDateTime()
  m.DateTimeTask.control = "RUN"
end sub

sub onParksChanged()
  m.parks = m.TodayParkHoursTask.parks

  m.mk_hours.text = m.parks["mk"].todaysHours
  m.ep_hours.text = m.parks["ep"].todaysHours
  m.hs_hours.text = m.parks["hs"].todaysHours
  m.ak_hours.text = m.parks["ak"].todaysHours
  m.ds_hours.text = m.parks["ds"].todaysHours
  m.tl_hours.text = m.parks["tl"].todaysHours
  m.bb_hours.text = m.parks["bb"].todaysHours

  updatePark()
end sub

sub onWeatherChanged()
  m.weather_info = m.WeatherTask.weather_info["weather"]
  m.weather.text = Substitute("Currently {0}°F ({1}°C) and {2}", m.weather_info.currently_temperature_f.ToStr(), m.weather_info.currently_temperature_c.ToStr(), LCase(m.weather_info.currently_summary))
end sub

sub onDateTimeChanged()
  m.datetime_info = m.DateTimeTask.datetime_info["datetime"]
  m.day_of_the_week.text = m.datetime_info.day_of_the_week
  m.month_day.text = m.datetime_info.month_day
  m.time.text = m.datetime_info.time
end sub

sub audioPlayerStateChanged()
  if (m.audio.state = "finished") then
    m.audio_track_index++

    if (m.audio_track_index > 16) then m.audio_track_index = 1

    changeAudioTrack()
  end if
end sub

sub changeAudioTrack()
  audiocontent = createObject("RoSGNode", "ContentNode")
  audiocontent.url = "https://wdwntnow.oseast-us-1.phoenixnap.com/music/today_at_wdw/" + m.audio_track_index.ToStr() + ".mp3"

  m.audio.content = audiocontent
  m.audio.control = "play"
end sub