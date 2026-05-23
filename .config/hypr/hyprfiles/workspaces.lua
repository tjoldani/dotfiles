-- Workspace-to-monitor assignments
hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })

-- Window rules
hl.window_rule({
    name  = "pavucontrol-rule",
    match = { class = "^(hyprpwcenter)$" },
    float     = true,
    animation = "slide top",
    size      = "400 800",
    move      = "1730 110",
})

hl.window_rule({
    name  = "nmtui-rule",
    match = { class = "^(nmtui)$" },
    float     = true,
    animation = "slide top",
    size      = "800 800",
    move      = "1327 110",
})

hl.window_rule({
    name  = "pip-rule",
    match = { title = "^(Picture-in-Picture)$" },
    float     = true,
    animation = "slide top",
    move      = "1545 55",
    size      = "600 300",
})

hl.window_rule({
    name  = "newnote-rule",
    match = { class = "^(newnote)$" },
    float     = true,
    animation = "popin",
    size      = "620 500",
    move      = "1500 110",
})

hl.window_rule({
    name  = "dailynote-rule",
    match = { class = "^(dailynote)$" },
    float     = true,
    animation = "popin",
    size      = "620 1235",
    move      = "1500 110",
})

hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})
