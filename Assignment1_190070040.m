function Y = Assignment1(netlist)
	netTable = readtable(netlist);
	comp = char(table2array(netTable(:,1)));
	pos = table2array(netTable(:,2));
	neg = table2array(netTable(:,3));
	val = table2array(netTable(:,4));
	if strcmp(class(val),'cell')
		val = str2double(val);
	end

	nodes = max(max(pos,neg));
	Y = zeros(nodes);
	m = size(comp,1);
	R = 'R'*ones(m,1);
	R = char(R);

	valid = (R==comp(:,1));

	for i = 1:nodes
	    posValid = ((pos.*valid)==(i*ones(m,1)));
	    negValid = ((neg.*valid)==(i*ones(m,1)));
	    netValid = posValid + negValid;
    
	    temp = val.*netValid;
	    temp = nonzeros(temp);
	    
	    Y(i,i) = sum(1./temp);
	end

	for a = 1:nodes
	    for b = 1:nodes
	        netValid = zeros(m,1);
        
	        posValid = ((pos.*valid)==(a*ones(m,1)));
	        negValid = ((neg.*valid)==(b*ones(m,1)));
	        temp2 = intersect(find(posValid),find(negValid));
	        if ~isempty(temp2)
	            for k = 1:size(temp2)
	                netValid(temp2(k)) = 1;
	            end
	        end
        

	        temp = val.*netValid;
	        temp = nonzeros(temp);
	        Y(a,b) = Y(a,b) - sum(1./temp);
	   	    Y(b,a) = Y(b,a) - sum(1./temp);
   		end
	end
end