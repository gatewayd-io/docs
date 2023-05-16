const toggleDarkMode = document.querySelector(".js-toggle-dark-mode")

setLightMode = function () {
  localStorage.setItem("dark-mode", "false")
  jtd.setTheme("light")
  toggleDarkMode.textContent = "🌑 Dark"
}

setDarkMode = function () {
  localStorage.setItem("dark-mode", "true")
  jtd.setTheme("dark")
  toggleDarkMode.textContent = "☀️ Light"
}

// Set the theme to the user's preference
setTheme = function () {
  let darkModeEnabled = localStorage.getItem("dark-mode")

  if (darkModeEnabled === null) {
    setLightMode()
  } else {
    if (darkModeEnabled === "false") {
      setLightMode()
    } else {
      setDarkMode()
    }
  }
}

// Set the theme on script load
setTheme()

// Toggle the theme on click of the button
toggleDarkMode.addEventListener("click", () => {
  if (jtd.getTheme() === "dark") {
    setLightMode()
  } else {
    setDarkMode()
  }
})

// Set the theme on page load
document.addEventListener("load", function () {
  setTheme()
})
