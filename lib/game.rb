require './lib/game_stats'

class Game
  include GameStats
  attr_reader :game_id,
              :season,
              :away_team_id, 
              :home_team_id, 
              :away_goals, 
              :home_goals

  def initialize(stats)
    @game_id = stats[:game_id]
    @season = stats[:season]
    @away_team_id = stats[:away_team_id]
    @home_team_id = stats[:home_team_id]
    @away_goals = stats[:away_goals].to_i
    @home_goals = stats[:home_goals].to_i
  end
end