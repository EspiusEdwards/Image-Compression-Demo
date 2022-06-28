# Duy Khoa Pham
# Student ID: 103515617
# Custom code for COS10009: Introduction to Programming
# K-Means algorithm in 2D dataset
# Euclid distance

# Import library
require 'rubygems'
require 'gosu'
require_relative './circle'
require 'rumale'


# The screen has 3 layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

# Set up screen dimension
WIN_WIDTH = 1400 
WIN_HEIGHT = 700

# Start GUI
class DemoWindow < Gosu::Window
  def initialize()
    # Window dimension
    super(WIN_WIDTH, WIN_HEIGHT, false)
    
    #color theme
    @background = Gosu::Color::rgb(188, 235, 203)
    @white = Gosu::Color::rgb(247, 255, 246)
    @nav = Gosu::Color::rgb(188, 235, 203)
    @rectangle = Gosu::Color::rgb(112, 224, 0)
    @black = Gosu::Color::BLACK

    #font theme
    @button_font = Gosu::Font.new(50)
    @button_font_distance =  Gosu::Font.new(45)
    @info_font = Gosu::Font.new(10)

    #Initial Variables
    @K = 0
    @distance = 0
    @points = []
    @clusters = []
    @labels = []
    @colours = [Gosu::Color::GREEN, Gosu::Color::BLUE, Gosu::Color::RED, Gosu::Color::YELLOW, Gosu::Color::FUCHSIA, Gosu::Color.rgb(255,52,179), 
      Gosu::Color.rgb(219,147,112),Gosu::Color.rgb(105,105,105), Gosu::Color.rgb(142,35,35)]
    
    # Image
    # Run icon
    @run_img = Gosu::Image.new("img/run.png")
    # Random icon
    @random_img = Gosu::Image.new("img/random.png")
    #Error icon
    @error_img = Gosu::Image.new("img/error.png")
    # Algorithm icon
    @algorithm_img = Gosu::Image.new("img/algorithm.png")
    # Reset icon
    @reset_img = Gosu::Image.new("img/reset.png")
  end
  

  #Draw points in screen and update labels of point
  def draw_point() 
    for i in (0..@points.length-1)
      img2 = Gosu::Image.new(Circle.new(8))
      img2.draw(@points[i][0] + 50, @points[i][1] + 50, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)

      # There is no labels
      if @labels == []
        img3 = Gosu::Image.new(Circle.new(6))
        img3.draw(@points[i][0] + 50 + 1.75, @points[i][1] + 50 + 1.75, ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)

      # Update color according to labels
      else
        img3 = Gosu::Image.new(Circle.new(6))
        img3.draw(@points[i][0] + 50 +1.75, @points[i][1] + 50 +  1.75, ZOrder::TOP, 1.0, 1.0, @colours[@labels[i]])
      end
    end
  end


  # Draw clusters in screen
  def draw_cluster()
    for i in (0..@clusters.length-1)
      img2 = Gosu::Image.new(Circle.new(10))
      img2.draw(@clusters[i][0]+50, @clusters[i][1]+50, ZOrder::TOP, 1.0, 1.0, @colours[i])
    end
  end

  # Assign label for each point
  def assign_label()
    @labels = []
    for p in @points
      distances_point_to_cluster = []
      for c in @clusters
        distant = couting_distance(p, c)
        distances_point_to_cluster.append(distant)
      end
      # labels: smallest distance to clusters
      @labels.append(distances_point_to_cluster.index(distances_point_to_cluster.min()))
    
    end
    
  end


  # Update cluster to centerpoint
  def update_clusters()
    for i in (0..@K-1)
      sum_x = 0
      sum_y = 0
      count = 0
      for p in (0..@points.length-1)
          if @labels[p] == i
              sum_x += @points[p][0]
              sum_y += @points[p][1]
              count += 1
          end
      end
      # Couting average value of obeservations in cluster
      if count != 0
          new_cluster_x = sum_x / count
          new_cluster_y = sum_y / count
          @clusters[i] = [new_cluster_x, new_cluster_y]
      end
    end
  end

  # Should update window => Alleviate processing power
  def needs_redraw?
    return @needs_redrawing  
  end


  # Update distance feature
  def update
    if @clusters != [] && @labels != []
      @distance = 0
      for i in (0..@points.length-1)
        @distance += couting_distance(@clusters[@labels[i]], @points[i])
      end
    end
  end


  # Draw rectangle
  def draw_rectangle(x,y,z,t, color = @rectangle, enum = ZOrder::MIDDLE)
    Gosu.draw_rect(x, y, z, t, color, enum, mode=:default)
  end

  # Draw button
  def draw_button(font, x, y, color = @black, button = @button_font)
    @button_font.draw_text(font, x, y, ZOrder::TOP, 1.0, 1.0, @black)
  end
 
  # Euclid distance couting in 2D dataset
  def couting_distance(p1, p2)
    return ((p1[0] - p2[0])**2 + (p1[1]-p2[1])**2)**0.5
  end

  # Draw everything on GUI
  def draw
    # Draw background color
    draw_rectangle(0, 0, WIN_WIDTH, WIN_HEIGHT, @background, ZOrder::BACKGROUND)

    # Draw INTERFACE
    draw_rectangle(50, 50, 800, 600, @nav)

    # Draw panel
    draw_rectangle(55, 55, 790, 590, @white, ZOrder::TOP)

    # K button +:
    # K button + rectangle
    draw_rectangle(1000, 50, 50, 50)

    # K button +
    draw_button("+", 1012, 49)
    
    # K button -:
    # K button - rectangle
    draw_rectangle(1150, 50, 50, 50)

    # K button -
    draw_button("-", 1168, 45)

    # K:
    # Draw K
    draw_button("K = " + @K.to_s(), 1250, 50)
    
    # Cirlce image
    img2 = Gosu::Image.new(Circle.new(50))

    # RANDOM
    # Random circle
    img2.draw(975, 290, ZOrder::TOP, 1.0, 1.0, @rectangle)

    # Random button
    @random_img.draw(990, 305, ZOrder::TOP)

    
    #RUN
    # Run circle
    img2.draw(975, 150, ZOrder::TOP, 1.0, 1.0, @rectangle)
    
    # Run button
    @run_img.draw(990, 165, ZOrder::TOP)

    #Error button
    @error_img.draw(1015, 430, ZOrder::TOP)
    draw_button("= " + @distance.to_i.to_s(), 1090, 440, @button_font_distance)

    # ALGORITHM
    # Algorithm Rectangle
    img2.draw(1125, 150, ZOrder::TOP, 1.0, 1.0, @rectangle)

    # Algorithm button
    @algorithm_img.draw(1140, 165, ZOrder::TOP)

    #RESET
    # Reset rectangle
    img2.draw(1125, 290, ZOrder::TOP, 1.0, 1.0, @rectangle)

    # Reset button
    @reset_img.draw(1140, 305, ZOrder::TOP)

    #Draw mouse position
    if (58 <  mouse_x && mouse_x < 834 and 58 < mouse_y && mouse_y < 634)
      # Draw the mouse_x position
      @info_font.draw_text("mouse_x: #{(mouse_x-50).to_i}", 50, 650, ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)

      # Draw the mouse_y position
      @info_font.draw_text("mouse_y: #{(mouse_y - 50).to_i}", 200, 650, ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)
    end 

    # Draw and update point
    draw_point()
    
    # Draw cluster
    draw_cluster()
    
    # Stop drawing 
    @needs_redrawing = false
  end

  # Mouse display
  def needs_cursor?; true; end
  
  # Buttion down
  def button_down(id)
    case id
    # Mouse click
    when Gosu::MsLeft
      @needs_redrawing = true

      #memorize point
      if (58 <  mouse_x && mouse_x < 834 and 58 < mouse_y && mouse_y < 634)
      # if (mouse_x > 50 && mouse_x < 850 and mouse_y > 50 && mouse_y < 650)
        @labels = []
        point = [(mouse_x-50).to_i, (mouse_y-50).to_i]
        # Add points to label
        @points.append(point)
        print(@points)
        print("\n")
      end

      #press +
      if (mouse_x > 1000 && mouse_x < 1050 and mouse_y > 50 && mouse_y < 100)
        # Maximum 9 clusters
        if @K < 9
          @K += 1
        end
      end

      #press -
      if (mouse_x > 1150 && mouse_x < 1200 and mouse_y > 50 && mouse_y < 100)
        # K have to > 0
        if @K > 0
          @K -=1
        end
      end

      #press Random(975, 290)
      if (mouse_x > 975 && mouse_x < 1075 and mouse_y > 290 && mouse_y < 390)
        @clusters = []
        @labels = []
        # Append random coordinate in clusters
        for i in (0..@K-1)
          @clusters.append([rand(0..750), rand(0..550)])
        end
        # print(@clusters)
      end

     # RUN (975, 150)
      if (mouse_x > 975 && mouse_x < 1075 and mouse_y > 150 && mouse_y < 250) && @clusters != []
        # Assign label
        assign_label()

        # Update centrer point for cluster
        update_clusters()
      end

      #ALGORITHM (1125, 150)
      if (mouse_x > 1125 && mouse_x < 1225 and mouse_y > 150 && mouse_y < 250)
        # Use Rumale library to run K Means
        if @K > 0
        kmeans = Rumale::Clustering::KMeans.new(n_clusters: @K).fit(@points)
        # Put labels
        @labels = kmeans.fit_predict(@points)
        # puts(@labels[0])
        # Set cluster to center and convert to array to apply to the code
        @clusters = kmeans.cluster_centers().to_a()
        end
      end

      #RESET (1125, 290)
      if (mouse_x > 1125 && mouse_x < 1225 and mouse_y > 290 && mouse_y < 390)
        # puts "Reset"
        # Reset every variable to 0 or []
        @points = []
        @labels = []
        @clusters = []
        @distance = 0
        @K = 0
      end

    else
      # stop drawing
      @needs_redrawing = false
      super(id)
    end

  end

  

end

DemoWindow.new.show()