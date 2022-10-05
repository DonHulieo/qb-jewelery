local Translations = {
    error = {
        fingerprints = 'Looks like I left a fingerprint on the glass..',
        minimum_police = 'I should try again when there\'s more police around..',
        wrong_weapon = 'This weapon isn\'t big enough..',
        to_much = 'You have to much in your pocket'
    },
    success = {},
    info = {
        progressbar = 'Smashing the display case',
    },
    general = {
        target_label = 'Smash the display case',
        drawtextui_grab = '[E] Smash the display case',
        drawtextui_broken = 'Display case is broken'
    }
}

Lang = Locale:new({phrases = Translations})
