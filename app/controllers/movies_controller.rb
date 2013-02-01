class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    @all_ratings = Movie.all_ratings
    if params.include? :commit
      if !params.include?(:ratings)
        params[:ratings] = Hash.new()
        @all_ratings.each { |rating| params[:ratings][rating] = 1 }
      end
      ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session.include? :ratings
      ratings = session[:ratings].keys
    else
      ratings = @all_ratings
    end
    if !params.include? :sort
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", ratings])
    elsif params[:sort] == "title"
      @movies = Movie.find(:all, :order => "title", :conditions => ["rating IN (?)", ratings])
    elsif params[:sort] == "date"
      @movies = Movie.find(:all, :order => "release_date", :conditions => ["rating IN (?)", ratings])
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
