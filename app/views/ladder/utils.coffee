{hslToHex} = require 'core/utils'

module.exports.teamDataFromLevel = (level) ->
  alliedSystem = _.find level.get('systems', true), (value) -> value.config?.teams?
  teamNames = (teamName for teamName, teamConfig of alliedSystem.config.teams when teamConfig.playable)
  if teamNames[0] is 'ogres' and teamNames[1] is 'humans'
    teamNames = ['humans', 'ogres']  # Make sure they're in the right order, since our other code is frail to the ordering
  teamConfigs = alliedSystem.config.teams

  teams = []
  for team in teamNames or []
    otherTeam = if team is 'ogres' then 'humans' else 'ogres'
    otherTeam
    if level.isType 'ladder'
      continue if team is 'ogres'
      otherTeam = null
    color = teamConfigs[team].color
    bgColor = hslToHex([color.hue, color.saturation, color.lightness + (1 - color.lightness) * 0.5])
    primaryColor = hslToHex([color.hue, 0.5, 0.5])
    if level.get('slug') in ['wakka-maul']
      displayName = _.string.titleize(team)
    else
      displayName = $.i18n.t("ladder.#{team}")  # Use Red/Blue instead of Humans/Ogres
    teams.push({
      id: team
      name: _.string.titleize(team)
      displayName: displayName
      otherTeam: otherTeam
      otherTeamDisplayName: if otherTeam then $.i18n.t("ladder.#{otherTeam}") else ''
      bgColor: bgColor
      primaryColor: primaryColor
    })

  teams

module.exports.scoreForDisplay = (score) ->
  return score * 100
