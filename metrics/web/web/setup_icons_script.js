'use strict';

function setupIcons() {
  const lightModeIcon = document.querySelector('link#light-mode-icon');
  const darkModeIcon = document.querySelector('link#dark-mode-icon');
  
  function setLight() {
    document.head.append(lightModeIcon);
    darkModeIcon.remove();
  }

  function setDark() {
    lightModeIcon.remove();
    document.head.append(darkModeIcon);
  }


  const matcher = window.matchMedia('(prefers-color-scheme:dark)');
  function onUpdate() {
    if (matcher.matches) {
      setDark();
    } else {
      setLight();
    }
  }
  matcher.addListener(onUpdate);
  onUpdate();
}

setupIcons();
