class RobotsController < ApplicationController
	attr_accessor :size_grid, :max_x, :max_y, :x, :y, :f, :commands, :report

	def initialize(params={})
	  	byebug
	    @x = params[:x].try(:to_i)
	    @y = params[:y].try(:to_i)
	    @f = params[:f] || ""
	    @size_grid = sanitize_size(params[:size_grid])
	    @max_x, @max_y = @size_grid.split('x').map(&:to_i)
	    @commands = params[:commands] || ""
	    @report = nil
  	end

	def new
    	@robot = Robot.new
  	end

  def create
    @robot = Robot.new(params[:robot_params])
    execute_commands
    if @robot.save
    	redirect_to @robot
    else 
    	render new
    end
  end


  def execute_commands
    # return unless check_if_robot_is_placed?

    commands = @commands.gsub(/\r\n/,' ')
    commands = commands.to_s.upcase.split(' ')
    commands.each_with_index do |command, index|
      placing_initial_coordinates(commands[index+1]) if command == "PLACE"
      case command
      when 'MOVE'
        move_into_new_position
      when 'LEFT'
        change_direction('LEFT')
      when 'RIGHT'
        change_direction('RIGHT')
      when 'REPORT'
        generate_report
        break
      end if self.isExists?
    end
    warning_message
  end

  def isExists?
    @x && @y && !@f.empty?
  end

  private

    # def check_if_robot_is_placed?
    #   if !self.isExists? && !@commands.include?("PLACE")
    #     @x, @y = ""
    #     flash[:notice] = "You might need to place the robot first"
    #     return false
    #   end
    #   return true
    # end

    def placing_initial_coordinates(args)
      @x, @y, @f = args.split(',')
      @x = @x.to_i
      @y = @y.to_i
    end

    def move_into_new_position
      case @f
      when 'NORTH'
        @y = @y+1 unless (@y+1) > (@max_y - 1)
      when 'WEST'
        @x = @x-1 unless (@x-1) < 0
      when 'SOUTH'
        @y = @y-1 unless (@y-1) < 0
      when 'EAST'
        @x = @x+1 unless (@x+1) > (@max_x -1)
      end
    end

    def change_direction(direction)
      case @f
      when 'NORTH'
        @f = direction.eql?('LEFT') ? 'WEST' : 'EAST'
      when 'WEST'
        @f = direction.eql?('LEFT') ? 'SOUTH' : 'NORTH'
      when 'SOUTH'
        @f = direction.eql?('LEFT') ? 'EAST' : 'WEST'
      when 'EAST'
        @f = direction.eql?('LEFT') ? 'NORTH' : 'SOUTH'
      end
    end

    def generate_report
      @report = "#{@x},#{@y},#{@f}"
    end

    def warning_message
      errors.add(:warning, 'Wrong direction! your robot is about to fall of..') unless check_warning
    end

    def check_warning
      case @f
      when "NORTH"
        return false
      when "WEST"
        return false if @x==0
      when "EAST"
        return false if @x==@max_x-1
      end if @y==@max_y-1

      case @f
      when "SOUTH"
        return false
      when "WEST"
        return false if @x==0
      when "EAST"
        return false if @x==@max_x-1
      end if @y==0

      return false if @x==@max_x-1 && @f == "EAST"
      return false if @x==0 && @f == "WEST"

      return true
    end

    def sanitize_size(size_grid)
      size_grid.to_s.match(/\dx\d/) ? size_grid : "5x5"
    end

    private
    # Use callbacks to share common setup or constraints between actions.

    def robot_params
      params.require(:robot).permit(:size_grid, :commands, :x, :y ,:f, :max_x, :max_y)
    end
end
