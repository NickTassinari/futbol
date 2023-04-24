require './lib/league_stats'
require './lib/season_stats'

class GameTeam
    include LeagueStats, SeasonStats
    attr_reader :game_id,
                :team_id,
                :hoa,
                :result,
                :settled_in,
                :head_coach,
                :goals,
                :shots,
                :tackles,
                :pim,
                :power_play_opportunities,
                :power_play_goals,
                :face_off_win_percentage,
                :giveaways,
                :takeaways
  attr_accessor :season
  
  def initialize(stats)
    @game_id = stats[:game_id]
    @team_id = stats[:team_id]
    @hoa = stats[:hoa]
    @result = stats[:result]
    @settled_in = stats[:settled_in]
    @head_coach = stats[:head_coach]
    @goals = stats[:goals].to_i
    @shots = stats[:shots].to_i
    @tackles = stats[:tackles].to_i
    @pim = stats[:pim].to_i
    @power_play_opportunities = stats[:power_play_opportunities].to_i
    @power_play_goals= stats[:power_play_goals].to_i
    @face_off_win_percentage = stats[:face_off_win_percentage].to_i
    @giveaways = stats[:giveaways].to_i
    @takeaways = stats[:takeaways].to_i
    @season = nil
  end
end