function onCreate()
    setPropertyFromClass('ClientPrefs', 'ghostTapping', false)

    if getPropertyFromClass('ClientPrefs', 'middleScroll') == true then
        setPropertyFromClass('ClientPrefs', 'middleScroll', false)
    end

    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'OldGameOver')
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'OldDeath')
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'OldRetry')
    setPropertyFromClass('GameOverSubstate', 'characterName', 'pbd')
    addCharacterToList('pbd', 'bf')

end

function onDestroy()
    setPropertyFromClass('ClientPrefs', 'ghostTapping', true)
end
