require './spec/spec_helper'

RSpec.describe StatTracker do 
  before(:each) do 
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
    @test_games = @stat_tracker.games[0..100]
  end
  
  describe '#initialize' do 
    it 'exists' do 
      expect(@stat_tracker).to be_a(StatTracker)
    end

    it 'has an array of games' do 
      expect(@stat_tracker.games).to be_a Array
      expect(@stat_tracker.games[0]).to be_a Game
    end
    
    it 'has an array of gameteams' do    
      expect(@stat_tracker.game_teams).to be_a Array
      expect(@stat_tracker.game_teams[0]).to be_a GameTeam
    end

    it 'game_teams have seasons by assignment' do 
      expect(@stat_tracker.game_teams[0].season).to eq('20122013')
    end
    
    it 'has an array of teams' do 
      expect(@stat_tracker.teams).to be_a Array
      expect(@stat_tracker.teams[0]).to be_a Team
    end
  end

  #game class

  describe '#total scores' do
    it 'can collect the sum of highest winning scores' do
      expect(@stat_tracker.highest_total_score).to eq(11)
    end

    it 'can collect the sum of lowest winning scores' do
      expect(@stat_tracker.lowest_total_score).to eq(0)
    end
  end

  describe '#percentage of wins' do 
    it 'can calculate the percentage of home wins' do 
      expect(@stat_tracker.percentage_home_wins).to eq(0.44)
    end 

    it 'can calculate the percentage of visitor wins' do 
      expect(@stat_tracker.percentage_visitor_wins).to eq(0.36)
    end

    it 'can calculate the percentage of ties per season' do 
      expect(@stat_tracker.percentage_ties).to eq(0.2)
    end
  end

  describe '#count games by season' do
    it 'counts number of games played per season' do
      hash = {"20122013"=>806, "20132014"=>1323, "20142015"=>1319, "20152016"=>1321, "20162017"=>1317, "20172018"=>1355}
      expect(@stat_tracker.count_of_games_by_season).to eq(hash)
    end
  end

  describe '#game averages' do 
    it 'can determine average goals per game' do 
      expect(@stat_tracker.average_goals_per_game).to eq(4.22)
    end

    it 'can determine average goals per season' do 
      expect(@stat_tracker.average_goals_by_season).to eq({
          "20122013"=>4.12,
          "20162017"=>4.23,
          "20142015"=>4.14,
          "20152016"=>4.16,
          "20132014"=>4.19,
          "20172018"=>4.44
      })
    end
  end

  #game_teams/league stats

  describe 'count of teams' do 
    it 'can count the total number of teams in the data' do 
      expect(@stat_tracker.count_of_teams).to eq(32)
    end
  end

  describe 'best offense' do 
    it 'can return team with highest average goals per game' do 
      expect(@stat_tracker.best_offense).to eq('Reign FC')
    end
  end

  describe 'worst offense' do 
    it 'can return team with lowest average goals per game' do 
      expect(@stat_tracker.worst_offense).to eq('Utah Royals FC')
    end
  end

  describe 'highest scoring avg' do 
    it 'can return name of team with highest avg score per game when they are away' do 
      expect(@stat_tracker.highest_scoring_visitor).to eq('FC Dallas')
    end
  
    it 'can return name of team with highest avg score per game when they are home' do 
      expect(@stat_tracker.highest_scoring_home_team).to eq('Reign FC')
    end
  end

  describe 'lowest scoring avg' do 
    it 'can return name of team with lowest score per game when they are away' do 
      expect(@stat_tracker.lowest_scoring_visitor).to eq('San Jose Earthquakes')
    end

    it 'can return name of team with lowest score per game when they are home' do
      expect(@stat_tracker.lowest_scoring_home_team).to eq('Utah Royals FC')
    end
  end

  # season stats

  describe '#accurate team' do
    it "names the team with the best ratio of shots to goals per season" do
      expect(@stat_tracker.most_accurate_team("20132014")).to eq "Real Salt Lake"
      expect(@stat_tracker.most_accurate_team("20142015")).to eq "Toronto FC"
    end

    it "names the team with the worst ratio of shots to goals per season" do
      expect(@stat_tracker.least_accurate_team("20132014")).to eq "New York City FC"
      expect(@stat_tracker.least_accurate_team("20142015")).to eq "Columbus Crew SC"
    end
  end

  describe '#tackles' do
    it "tracks the team with the most tackles per season" do
      expect(@stat_tracker.most_tackles("20132014")).to eq "FC Cincinnati"
      expect(@stat_tracker.most_tackles("20142015")).to eq "Seattle Sounders FC"
    end

    it 'tracks the team with the least tackles per season' do 
      expect(@stat_tracker.fewest_tackles("20132014")).to eq "Atlanta United"
      expect(@stat_tracker.fewest_tackles("20142015")).to eq "Orlando City SC"
    end
  end
  
#helpers

  #season_stats

  describe 'coach quality' do
    it '#winningest_coach' do 
      expect(@stat_tracker.winningest_coach("20122013")).to eq('Dan Lacroix')
      expect(@stat_tracker.winningest_coach("20162017")).to eq('Bruce Cassidy')
    end

    it "#worst_coach" do
      expect(@stat_tracker.worst_coach("20122013")).to eq('Martin Raymond')
      expect(@stat_tracker.worst_coach("20162017")).to eq('Dave Tippett')
    end
  end

  describe 'helpers' do 
    it '#total_goals' do 
      expect(@stat_tracker.total_goals(@test_games)).to eq(397)
    end

    it '#season_by_id' do 
      expect(@stat_tracker.season_by_id('2012030312')).to eq('20122013')
    end
  end
end