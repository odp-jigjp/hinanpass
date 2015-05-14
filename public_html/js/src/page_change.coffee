# ページ遷移
window.pageChange = ->
  hash = location.hash

  window.scrollTo 0, 0
  
  if !hash
    buttonList()
  else
    if hash.match(/[a-zA-Z]+/g).length == 1
      switch hash.match(/[a-zA-Z]+/)[0]
        when 'earthquake','flood','hightide','tsunami','inundation','eruption','fire','typhoon','landslide'
          guidance()
          break
        when 'all'
          makeMapView()
          break
        when 'license'
          license()
          break
        when 'about'
          aboutThisApp()
          break
        else
          buttonList()
    else if hash.match(/[a-zA-Z]+/g).length == 2
      switch hash.match(/[a-zA-Z]+/)[0]
        when 'earthquake','flood','hightide','tsunami','inundation','eruption','fire','typhoon','landslide'
          makeMapView()
          break
        else
          buttonList()


$(window).hashchange ->
  pageChange()
