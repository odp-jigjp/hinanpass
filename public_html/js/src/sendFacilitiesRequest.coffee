# エリアコードから避難所情報を取得
window.sendFacilitiesRequest = (currentLat,currentLong) ->
  url = t 'sparql.url.facilities'
  queryParts = t 'sparql.query.baseFacilities'
  disasterName = location.hash.match(/[a-zA-Z]+/)[0]
  console.log currentLat , currentLong

  distanceThreshold = 10 #[km]

  latdelta = distanceThreshold * 360 / 40076.5 #[deg]
  longdelta = distanceThreshold * 360 / 40008.6 / Math.cos(currentLat * Math.PI / 180) #[deg]

  results = new Array()
  endRequestNumber = 0

  # localize.coffee内に投げているクエリ(の一部)がある
  query = queryParts[0] + t('sparql.query.kind.' + disasterName) + 
          queryParts[1] + (currentLat - latdelta) +
          queryParts[2] + (currentLat + latdelta) +
          queryParts[3] + (currentLong - longdelta) +
          queryParts[4] + (currentLong + longdelta) +
          queryParts[5]

  $.jsonp {
    url: url,
    callbackParameter: 'callback',
    cache: false,
    data: 
      output: 'json',
      app_name: 'hinankun',
      query: query
    ,
    success: (json, httpStatus) ->
      results = results.concat dataParse json.results.bindings
      endRequestNumber++
    ,
    error: (xOptions, textStatus) ->
      # PENDING
      alert t 'error.traffic'
  }

  do callFacilitySet = ->
    if endRequestNumber >= 1
      facilitiesSet results
    else
      setTimeout callFacilitySet , 50

  dataParse = (data) ->
    parsedData = new Array()
    for datum in data
      parsedDatum = 
        lat: datum.lat.value
        long: datum.long.value
      if datum.address
        parsedDatum.address = datum.address.value
      if datum.category
        parsedDatum.category = datum.category.value
      if datum.name
        parsedDatum.name = datum.name.value
      if datum.description
        parsedDatum.description = datum.description.value
      if datum.capacity
        parsedDatum.capacity = datum.capacity.value
      if datum.target
        parsedDatum.target = datum.target.value
      if datum.note
        parsedDatum.note = datum.note.value
      if datum.landslide
        parsedDatum.landslide = datum.landslide.value
      if datum.sealevel
        parsedDatum.sealevel = datum.sealevel.value
      if datum.height
        parsedDatum.height = datum.height.value
      if datum.telephone
        parsedDatum.telephone = datum.telephone.value
      parsedData.push parsedDatum

    return parsedData