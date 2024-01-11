if status is-interactive
    # Commands to run in interactive sessions can go here
end

# hide the greeting message while fish boot
set fish_greeting

# starship config
starship init fish | source
