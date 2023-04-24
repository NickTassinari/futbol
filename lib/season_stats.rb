module SeasonStats

  def winningest_coach(the_season)
    season_game_teams = @game_teams.select{|game_team| game_team.season == the_season}
    coach_wins = Hash.new(0)
    coach_games = Hash.new(0)
    season_game_teams.each do |game|
      coach = game.head_coach
      if game.result == 'WIN'
        coach_wins[coach] += 1
        coach_games[coach] += 1
      else
        coach_games[coach] += 1
      end
    end
    win_statistic_by_coach = {}
    coach_games.each do |coach, games|
      win_statistic_by_coach[coach] = (coach_wins[coach].to_f).fdiv(games.to_f)
    end
    win_statistic_by_coach.max_by{ |coach, win_statistic| win_statistic}[0]
  end
  

  def worst_coach(the_season)
    season_game_teams = @game_teams.select{|game_team| game_team.season == the_season}
    coach_losses = Hash.new(0)
    coach_ties = Hash.new(0)
    coach_games = Hash.new(0)
    season_game_teams.each do |game|
      coach = game.head_coach
      if game.result == 'WIN'
        coach_games[coach] += 1
      elsif game.result == 'LOSS' 
        coach_losses[coach] += 1
        coach_games[coach] += 1
      elsif game.result == 'TIE' 
        coach_ties[coach] += 1
        coach_games[coach] += 1
      end
    end
    win_statistic_by_coach = {}
    coach_games.each do |coach, games|
      wins = games - coach_losses[coach] - coach_ties[coach]
      win_statistic_by_coach[coach] = (wins.to_f).fdiv(games.to_f)
    end
    win_statistic_by_coach.min_by{ |coach, win_statistic| win_statistic}[0]
  end

  def most_accurate_team(season)
    team_ratios = Hash.new { |hash, key| hash[key] = [0, 0] }
  
    games_in_season = @games.select { |game| game.season == season }
    games_in_season.each do |game|
      home_team_id = game.home_team_id
      away_team_id = game.away_team_id
  
      home_team_stats = @game_teams.find { |team| team.game_id == game.game_id && team.team_id == home_team_id }
      away_team_stats = @game_teams.find { |team| team.game_id == game.game_id && team.team_id == away_team_id }
  
      home_shots = home_team_stats.shots.to_f
      home_goals = home_team_stats.goals.to_f
      away_shots = away_team_stats.shots.to_f
      away_goals = away_team_stats.goals.to_f
  
      home_team = @teams.find { |team| team.team_id == home_team_id }
      away_team = @teams.find { |team| team.team_id == away_team_id }
  
      team_ratios[home_team.team_name][0] += home_shots
      team_ratios[home_team.team_name][1] += home_goals
      team_ratios[away_team.team_name][0] += away_shots
      team_ratios[away_team.team_name][1] += away_goals
    end
  
    accuracies = {}
    team_ratios.each do |team_name, (shots, goals)|
      if shots > 0
        accuracy = goals / shots
        accuracies[team_name] = accuracy
      end
    end
    accuracies.max_by { |_, accuracy| accuracy }.first
  end

  def least_accurate_team(season)
    filtered_game_teams = @game_teams.select { |game| game.game_id.start_with?(season[0, 4]) }
    grouped_game_teams = filtered_game_teams.group_by { |game_team| game_team.team_id }
    goals_and_shots = grouped_game_teams.transform_values do |games|
      total_goals = games.sum(&:goals).to_i
      total_shots = games.sum(&:shots).to_i
      accuracy = (total_goals.to_f / total_shots).round(5)
      [total_goals, total_shots, accuracy]
    end
    team_id, _total_goals, _total_shots, accuracy = goals_and_shots.min_by { |_team_id, (total_goals, total_shots, accuracy)| accuracy }
    least_accurate_team = @teams.find { |team| team.team_id == team_id.to_s }
    least_accurate_team.team_name
  end
  

  def most_tackles(season)
    games_for_season = @games.find_all { |game| game.season == season }
    game_teams_for_season = @game_teams.find_all do |game_team|
      games_for_season.any? { |game| game.game_id == game_team.game_id }
    end
  
    team_tackles = game_teams_for_season.group_by(&:team_id).transform_values do |game_teams|
      game_teams.sum(&:tackles)
    end
  
    team_with_most_tackles = team_tackles.sort_by { |_, tackles| tackles }.last.first
    @teams.find { |team| team.team_id == team_with_most_tackles }.team_name
  end

    
  def fewest_tackles(season)
    games_in_season = filter_game_teams_by_season(season)
    games_by_team = games_in_season.group_by{|game_team| game_team.team_id}
    total_tackles = tackles_by_team(games_by_team)
    team = total_tackles.min_by{|team, tackles| tackles}
    team_by_id(team.first)
  end

  # Helper Methods

  def filter_game_teams_by_season(season)
    year = season[0,4]
    @game_teams.select{|game| game.game_id.start_with?(year)}
  end

  def tackles_by_team(hash)
    hash.transform_values do |games| 
      games.sum{|game| game.tackles}
    end
  end

  def team_by_id(id)
    team = @teams.find{|team| team.team_id == id.to_s}
    team.team_name
  end

  def season_by_id(id)
    seasonal_game = @games.find do |game|
      game.game_id == id
    end
    seasonal_game.season 
  end
end