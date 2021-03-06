function executeTask() as void
  urlTransfer = createUrlTransfer("https://wdwnt-now-api.herokuapp.com/api/parks?sort=true")
  json = getJson(urlTransfer)

  parks = CreateObject("roAssociativeArray")

  mk = buildParkNode(json, 0)
  parks.AddReplace("mk", mk)

  ep = buildParkNode(json, 1)
  parks.AddReplace("ep", ep)

  hs = buildParkNode(json, 2)
  parks.AddReplace("hs", hs)

  ak = buildParkNode(json, 3)
  parks.AddReplace("ak", ak)

  ds = buildParkNode(json, 4)
  parks.AddReplace("ds", ds)

  tl = buildParkNode(json, 5)
  parks.AddReplace("tl", tl)

  bb = buildParkNode(json, 6)
  parks.AddReplace("bb", bb)

  m.top.parks = parks
end function

function buildParkNode(json, index)
  park = CreateObject("roSGNode", "ParkNode")
  park.name = json[index].name
  park.imageUrl = json[index].imageUrl
  park.todaysHours = json[index].todaysHours
  park.tomorrowsHours = json[index].tomorrowsHours

  return park
end function
