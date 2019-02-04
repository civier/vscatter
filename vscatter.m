function [x,y] = vscatter(vals,MARKER_SIZE)

    % VSCATTER 
    % One dimensional vertical scatterplot which emphasizes distribution of
    % values by presenting close-by values (difference less than MARKER_SIZE) in a row.
    % Good for plotting all experimental values without markers overlapping
    % each other.
    % The y of each row is the average of values in that row. Some rows
    % might be shifted up by a maximum of MARKER_SIZE to prevent overlap.
    %
    % USAGE:
    %
    % vscatter(vals,MARKER_SIZE)
    %
    % vals - values to plot
    % MARKER_SIZE - diameter of the marker representing each data point, given in the units of the y-axis. 
    % Deafult is range(vals)/50. It is recommended to first use the default parameter, plot the data, 
    % measure the size of the marker in y-axis units, and then re-run the function using appropriate value. 
    %
    % OUTPUT:
    %
    % x - x values for plot function. 
    % y - y values for plot function
    %
    % USAGE EXAMPLE:
    %
    % [x,y] = vscatter(vec)
    % plot(x,y,'o')
    % axis equal
    %
    %
    % Date: 21 Aug 2016 	
    % Version: 	1.6.0.0
    % Author: Oren Civier

    % if marker size not specific, use a reasonable    
    if ~exist('MARKER_SIZE')
        MARKER_SIZE = range(vals) / 50;
    end
  
    % set rows and svals, such that rows(i) gives the row of the data point svals(i)
    svals = sort(vals);
    curr_val = svals(1);
    rows(1) = 1;
    curr_row = 1;
    for i=2:length(svals)
        if svals(i) > curr_val + MARKER_SIZE
            curr_row = curr_row + 1;
            curr_val = svals(i);
        end
        rows(i) = curr_row;
    end

    % set xs(i) to space out on the x-axis the values in each row of values
    for row=1:max(rows)
        is = find(rows == row);
        width = (length(is)-1) * MARKER_SIZE;
        xs(is) = linspace(-width/2,+width/2,length(is));
    end
    
    % set xs_rand(i) to have the values spaced out, but with randomized order (so it looks like a distribution)
    for row=1:max(rows)
        is = find(rows == row);
        xs_rnd(is) = xs(is(randperm(length(is))));
    end
    
    % set avg_svals(i) such that all data points in each row will have the same value. The distribution looks nicer this way
    for row=1:max(rows)
        is = find(rows == row);
        avg_val  = mean(svals(is)); % max - similar to SPSS (but SPSS also pushes values up if overlap)
        avg_svals(is) = avg_val;
    end
    
    % if there are overlapping rows, push up some rows a bit. The idea is to clarify the distribution on the expense of accuracy
    avg_svals_space = avg_svals;
    for row=2:max(rows)
        is = find(rows == row);
        if avg_svals(is(1)) - avg_svals(is(1)-1) < MARKER_SIZE
           avg_svals_space(is) = ones(length(is),1) * (avg_svals(is(1)-1) + MARKER_SIZE)
        end
    end

    x = xs;
    y = avg_svals_space;
end
