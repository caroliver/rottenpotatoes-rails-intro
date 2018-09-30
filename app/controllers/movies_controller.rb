class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    params[:ratings] ||= session[:selected_ratings]
    session[:selected_ratings] = params[:ratings]
   
    params[:sort_method] ||= session[:sort_type]
    session[:sort_type] = params[:sort_method]
    
    @selected_ratings = session[:selected_ratings]
    @sort_type = session[:sort_type]
    
    if @selected_ratings == nil
      @check_hash = {"G" => "2", "PG" => "2","PG-13" => "2", "R" => "2"}
      @selected_ratings = Movie.all_ratings
      case @sort_type
      when 'movie_title'
        @title_header = "hilite"
        @movies = Movie.where(:rating => @selected_ratings).order(:title => :asc)
      when 'date_released'
        @release_date_header = "hilite"
        @movies = Movie.where(:rating => @selected_ratings).order(:release_date => :asc)
      else
        @movies = Movie.where(:rating => @selected_ratings)
      end
    
    else
      @check_hash = @selected_ratings
      case @sort_type
      when 'movie_title'
        @title_header = "hilite"
        @movies = Movie.where(:rating => @selected_ratings.keys).order(:title => :asc)
      when 'date_released'
        @release_date_header = "hilite"
        @movies = Movie.where(:rating => @selected_ratings.keys).order(:release_date => :asc)
      else
        @movies = Movie.where(:rating => @selected_ratings.keys)
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash.keep[:notice] = "#{@movie.title} was successfully created."
    redirect_to :sort_method => @sort_type, :ratings => @selected_ratings and return 
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash.keep[:notice] = "#{@movie.title} was successfully updated."
    redirect_to :sort_method => @sort_type, :ratings => @selected_ratings and return 
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash.keep[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to :sort_method => @sort_type, :ratings => @selected_ratings and return 
  end

end
