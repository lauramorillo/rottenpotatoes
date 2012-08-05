class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if params[:order].nil? && params[:ratings].nil?
      if session[:order].present? || session[:ratings].present?
        flash.keep
        redirect_to :action => "index", :ratings => session[:ratings], :order => session[:order]
      end
    else
      session[:order] = params[:order] if params[:order].present?
      session[:ratings] = params[:ratings] if params[:ratings].present?

      @movies = Movie.scoped(:conditions => {})
      @all_ratings = Movie.ratings
      if session[:order].present?
        @movies = @movies.order(session[:order])
      end
      @movies = @movies.where(:rating => session[:ratings].try(:keys))
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
