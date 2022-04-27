function [cut] = ff_max_flow(source, sink, capacity)
    len = length(capacity);
    current_flow = zeros(len,len);
    max_flow = 0;
    cut = [];
    path = bfs_augmentedpath(source,sink,current_flow,capacity);
    while ~isempty(path)
        inc = inf;
        for i=1:length(path)-1
            inc = min(inc, capacity(path(i),path(i+1))-current_flow(path(i),path(i+1)));
        end
        for i=1:length(path)-1
            current_flow(path(i),path(i+1))=current_flow(path(i),path(i+1))+inc;
            current_flow(path(i+1),path(i))=current_flow(path(i+1),path(i))-inc;
        end
        max_flow = max_flow + inc;
        path = bfs_augmentedpath(source,sink,current_flow,capacity);
    end    
    visited = zeros(length(capacity));
    DFS(capacity, source, visited);
%     finding the min cut path
    for i = 1:len
        for j = 1:len
           if(current_flow(i,j) > 0 && visited(i) == 1 && visited(j) ==0)
                cut(i,j) = [i,j];
           end
        end
    end
end

function DFS(capacity, source, visited)
        visited(source) = 1;
        for m = 1: length(capacity)
            if (capacity(source,m) > 0 && visited(m) == 0)
                DFS(capacity, m,visited);
            end
        end
end

function path = bfs_augmentedpath(source, sink, current_flow,capacity)
    front = 1;
    back = 2;
    N = length(capacity);
    c(1:N) = 0;
    q =[];
    path = [];
    q = [source q];
    c(source) = front;  
    pred = zeros(1:N);
    pred(source) = source;
    
    while ~isempty(q)
        u = q(end);
        q(end) = [];
        c(u) = back;
        
        for v = 1:N
            if (c(v)==0 && capacity(u,v)>current_flow(u,v))
                q = [v q];
                c(v) = front;
                pred(v) = u;
            end
        end
    end
    if (c(sink) == back)
        temp = sink;
        while (pred(temp) ~= source)
            path = [pred(temp) path];
            temp = pred(temp);
        end
        path = [source path sink];
    else
        path = [];
    end
end

