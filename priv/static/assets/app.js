const get_filters = () => {
    const nameSearch = document.getElementById("search-name").value
    const filter = localStorage.getItem("filter")
    const order = localStorage.getItem("order")

    return {
        name: nameSearch,
        filter: filter,
        order: order
    }
}
  
  const get_paginator = () => {
    current_page = parseInt(document.getElementById("current_page").textContent)
    per_page = document.getElementById("per_page_selector").value
  
    return {
      current_page,
      per_page
    }
  }
  
  const previosPage = () => {
    const {current_page, per_page} = get_paginator()
  
    send_request((current_page - 1), per_page)
  }
  
  const nextPage = () => {
    const {current_page, per_page} = get_paginator()
    console.log("current_page: ", current_page)
    console.log("per_page: ", per_page)
  
    send_request((current_page + 1), per_page)
  }
  
  const search_name = () => {
    const {current_page, per_page} = get_paginator()
    send_request(current_page, per_page)
  }
  
  const sort_total_rushing_yards = () => {
    const sortTotalRushingYards = document.getElementById("sort_total_rushing_yards").value
    reset_ordenator()
    set_ordenator(sortTotalRushingYards, "total_rushing_yards")
    const {current_page, per_page} = get_paginator()
    send_request(current_page, per_page)
  }
  
  const sort_longest_rush = () => {
    const sortLongestRush = document.getElementById("sort_longest_rush").value
    reset_ordenator()
    set_ordenator(sortLongestRush, "longest_rush")
    const {current_page, per_page} = get_paginator()
    send_request(current_page, per_page)
  }
  
  const sort_total_rushing_td = () => {
    const sortTotalRushingTd = document.getElementById("sort_total_rushing_td")
    reset_ordenator()
    set_ordenator(sortTotalRushingTd, "total_rushing_touchdowns")

    const {current_page, per_page} = get_paginator()
    send_request(current_page, per_page)
  }

  const set_ordenator = (element, fitler) => {
    order = localStorage.getItem("order")
    console.log(order)
    switch (order) {
      case "asc":
        localStorage.setItem("filter", fitler);
        localStorage.setItem("order", "desc");
        break;
      case "":
        localStorage.setItem("filter", fitler);
        localStorage.setItem("order", "asc");
        break;
      case "desc":
        localStorage.setItem("filter", "");
        localStorage.setItem("order", "");
        break;
    }
  }

  const reset_ordenator = () => {
    const sortTotalRushingYards = document.getElementById("sort_total_rushing_yards")
    const sortLongestRush = document.getElementById("sort_longest_rush")
    const sortTotalRushingTd = document.getElementById("sort_total_rushing_td")

    localStorage.setItem("filter", "");
  }

  const send_request = (current_page, per_page) => {
    const {name, filter, order} = get_filters()

    const url = `http://localhost:4000/api/statistics/page/${current_page}/per_page/${per_page}?` + new URLSearchParams({
      name: name,
      filter: filter,
      order: order
    })

    fetch(url)
    .then(function(response) {
      response.json().then(
        function(decoded) {
          console.log(JSON.parse(decoded))
          const {result, page, has_next, has_prev} = JSON.parse(decoded);
    
          build_table(result)
          build_paginator(page, has_next, has_prev)
        }
      )
    })
  }

  const download = () => {
    const {name, filter, order} = get_filters()

    const url = `http://localhost:4000/api/statistics/download?` + new URLSearchParams({
      name: name,
      filter: filter,
      order: order
    })

    window.open(url)
  }

  const build_paginator = (current_page, has_next, has_prev) => {
    paginator = document.getElementById("nav_paginator")
  
    per_page = document.getElementById("per_page_selector").value
    list_pages = document.createElement("ul")
    list_pages.setAttribute("class", "pagination")
  
    previosPageLi = document.createElement("li")
    previosPageA = document.createElement("a")
    previosPageA.textContent = "Previous"
    previosPageA.setAttribute("onclick", "previosPage()")
    previosPageA.setAttribute("class", "page-link")
    has_prev ? previosPageLi.setAttribute("class", "page-item") : previosPageLi.setAttribute("class", "page-item disabled")
    previosPageLi.appendChild(previosPageA)
    
    nextPageLi = document.createElement("li")
    nextPageA = document.createElement("a")
    nextPageA.textContent = "Next"
    nextPageA.setAttribute("onclick", "nextPage()")
    nextPageA.setAttribute("class", "page-link")
    has_next ? nextPageLi.setAttribute("class", "page-item") : nextPageLi.setAttribute("class", "page-item disabled")
    nextPageLi.appendChild(nextPageA)
  
    currentPageLi = document.createElement("li")
    currentPageA = document.createElement("a")
    currentPageA.textContent = current_page
    currentPageA.setAttribute("id", "current_page")
    currentPageA.setAttribute("class", "page-link")
    currentPageLi.setAttribute("class", "page-item active")
    currentPageLi.appendChild(currentPageA)
  
    list_pages.appendChild(previosPageLi)
    list_pages.appendChild(currentPageLi)
    list_pages.appendChild(nextPageLi)
  
    paginator.replaceChildren(list_pages)
  }
  
  const build_table = (body) => {
    const fragment = document.createDocumentFragment()
    const table = document.getElementById("rush")
    table_header = document.createElement("tr")
  
    // TODO: deixar com nome apreviado que deram
    // TODO: colocar onhover para mostrar nome todo
    table_header.innerHTML = "<tr>\
      <th scope='col'><div class='text-truncate'>player_name</div></th>\
      <th scope='col'><div class='text-truncate'>player_team_abbreviation</div></th>\
      <th scope='col'><div class='text-truncate'>player_position</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_attempts_per_game_average</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_attempts</div></th>\
      <th scope='col' class='clickable'><div class='text-truncate' onclick='sort_total_rushing_yards()' id='sort_total_rushing_yards' value=''>total_rushing_yards</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_average_yards_per_attempt</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_yards_per_game</div></th>\
      <th scope='col' class='clickable'><div class='text-truncate' onclick='sort_total_rushing_td()' id='sort_total_rushing_td' value=''>total_rushing_touchdowns</div></th>\
      <th scope='col' class='clickable'><div class='text-truncate' onclick='sort_longest_rush()' id='sort_longest_rush' value=''>longest_rush</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_first_downs</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_first_down_percentage</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_more_than_twenty_yards</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_more_than_forty_yards</div></th>\
      <th scope='col'><div class='text-truncate'>rushing_fumbles</div></th>\
    </tr>"
  
    fragment.appendChild(table_header)
  
    body.map((element) => {
        line = document.createElement("tr")
        
        // TODO: trocar tudo isso por um looping na order certa de render
        player_name = document.createElement("td")
        player_name.textContent = element.player_name
        line.appendChild(player_name)
  
        player_team_abbreviation = document.createElement("td")
        player_team_abbreviation.textContent = element.player_team_abbreviation
        line.appendChild(player_team_abbreviation)
  
        player_position = document.createElement("td")
        player_position.textContent = element.player_position
        line.appendChild(player_position)
  
        rushing_attempts_per_game_average = document.createElement("td")
        rushing_attempts_per_game_average.textContent = element.rushing_attempts_per_game_average
        line.appendChild(rushing_attempts_per_game_average)
  
        rushing_attempts = document.createElement("td")
        rushing_attempts.textContent = element.rushing_attempts
        line.appendChild(rushing_attempts)
  
        total_rushing_yards = document.createElement("td")
        total_rushing_yards.textContent = element.total_rushing_yards
        line.appendChild(total_rushing_yards)
  
        rushing_average_yards_per_attempt = document.createElement("td")
        rushing_average_yards_per_attempt.textContent = element.rushing_average_yards_per_attempt
        line.appendChild(rushing_average_yards_per_attempt)
  
        rushing_yards_per_game = document.createElement("td")
        rushing_yards_per_game.textContent = element.rushing_yards_per_game
        line.appendChild(rushing_yards_per_game)
  
        total_rushing_touchdowns = document.createElement("td")
        total_rushing_touchdowns.textContent = element.total_rushing_touchdowns
        line.appendChild(total_rushing_touchdowns)
  
        longest_rush = document.createElement("td")
        longest_rush.textContent = element.longest_rush
        line.appendChild(longest_rush)
  
        rushing_first_downs = document.createElement("td")
        rushing_first_downs.textContent = element.rushing_first_downs
        line.appendChild(rushing_first_downs)
  
        rushing_first_down_percentage = document.createElement("td")
        rushing_first_down_percentage.textContent = element.rushing_first_down_percentage
        line.appendChild(rushing_first_down_percentage)
  
        rushing_more_than_twenty_yards = document.createElement("td")
        rushing_more_than_twenty_yards.textContent = element.rushing_more_than_twenty_yards
        line.appendChild(rushing_more_than_twenty_yards)
  
        rushing_more_than_forty_yards = document.createElement("td")
        rushing_more_than_forty_yards.textContent = element.rushing_more_than_forty_yards
        line.appendChild(rushing_more_than_forty_yards)
  
        rushing_fumbles = document.createElement("td")
        rushing_fumbles.textContent = element.rushing_fumbles
        line.appendChild(rushing_fumbles)
  
        fragment.appendChild(line)
    })
  
    table.replaceChildren(fragment)
  }
  
  localStorage.setItem("filter", "");
  localStorage.setItem("order", "");
  send_request(1, 10)