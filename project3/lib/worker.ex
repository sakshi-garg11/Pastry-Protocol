defmodule Project3.Worker do
    use GenServer

    def start_link(args) do
        GenServer.start_link(__MODULE__,{:ok,args},name: args)
        #GenServer.start_link(module, args, options \\ [])
        
    end
    
    def attachment(global,list) do
        #Project3.Worker.attachment(global, list)
        fu=fn(x)->
            nextIdent=x|>Atom.to_string
            #Atom.to_string(atom)
            list=table(list,global,nextIdent)
            collection=elem(list,0)
            #Kernel.elem(tuple, index)
           
            f=fn(x)->
                GenServer.cast({x,node()},{:combine,list,global,x,1})
            end
            Enum.map(Map.values(collection),f)
            #Enum.map(enumerable, fun)
            #Map.values(map)
           
            
        end
        Enum.map(Map.values(elem(list,0)),fu)
        pathVar=elem(list,0)
        f=fn(x)->
            x=x|>Atom.to_string
            #Enum.map(Atom.to_string(x=x))
            if x != nil do
                list=table(list,global,x) 
                elem(list,2)
            end
        end

        mn= fn->elem(list,2) end
        temp = Enum.map(Map.values(pathVar),f)|>Enum.max(mn)
        list=Tuple.delete_at(list,2)|>Tuple.insert_at(2,temp)
        #Enum.map(Tuple.delete_at(list,2),& Tuple.insert_at(2,temp)
        list=leafNode(list)
        f=fn(x)->
            GenServer.cast({x,node()},{:combine,list,global,x,1})
            #GenServer.cast(server, request)
        end
        Enum.map(Map.values(elem(list,0)),f)
        f=fn(x)->
            GenServer.cast({x|>String.to_atom,node()},{:combine,list,global,x|>String.to_atom,1})
        end
        Enum.map(Map.values(elem(list,1)),f)
    end


    def handle_call({selection,imp,presentID,identity},_from,list) do
        #Project3.Worker.handle_call(msg, from, state)
        case selection do
            :verify->
                collection=elem(list,0)
                #Kernel.elem(tuple, index)
                initial=:crypto.hash(:sha,presentID|>Integer.to_string)
                initial=initial|>Base.encode16|>Convertat.from_base(16) 
                |> Convertat.to_base(2)|>String.slice(0..127)
                val=initial|>Convertat.from_base(2)|>Convertat.to_base(4)|>String.to_atom
                collection=Map.put(collection,presentID,val)
                list=Tuple.delete_at(list,0)
                list=Tuple.insert_at(list,0,collection)
                {:reply,"",list}
            :attach->
                global=imp|>Atom.to_string
                #Enum.map(Atom.to_string(), &global=imp) 
                attachment(global,list)
                {:reply,list,list}
            
                :state->
                    {:reply,list,list}

                :connect->
                        map=elem(list,2)
                        pqr = fn(x)->
                            #GenServer.call(server, request, timeout \\ 5000)
                            variable=GenServer.call({x|>String.to_atom,node()},{:state,1,1,1},5000)
                            GenServer.cast({identity,node()},{:combine,variable,identity,identity,1})
                        end
                        Enum.map(Map.values(map),pqr)
                        
                        {:reply,list,list}
                 
        end
    end

  

    def init({:ok,_args}) do
       {:ok,{%{},%{},%{}}} 
    end

    def handle_cast({selection,imp,presentID,identity,hops},list) do 
        #Project3.Worker.handle_cast(msg, state)  
            case selection do
                :combine->
                        state_temp=imp
                        pathVar=elem(state_temp,2)
                        global=identity|>Atom.to_string
                        
                        f=fn(x)->
                            if x != nil do
                                list=table(list,global,x) 
                                elem(list,2)
                            end
                        end
                        op = fn->elem(list,2) end
                        temp = Enum.map(Map.values(pathVar),f)|>Enum.max(op)
                        list=Tuple.delete_at(list,2)|>Tuple.insert_at(2,temp)
                        #Tuple.delete_at(tuple, index)
                        #Tuple.insert_at(tuple, index, value)
                        list=leafNode(list)
                        {:noreply,list}
                :path->
                    {:ok, pid} =
                    Task.start_link fn -> 
                        #Task.start_link(fun)
                   
                    end
                  
                  ref = Process.monitor(pid)
                  #Process.monitor(item)
                  receive do
                    {:DOWN, ^ref, _, _, _} -> :task_is_down
                  after
                    100 -> :timeout # Optional timeout
                  end
                  
                        
                            fir=imp |> Atom.to_string
                            sec=identity |> Atom.to_string
                            if(fir==sec) do
                                GenServer.call({:Server,node()},{:server,presentID,hops},5000)
                                #GenServer.call(server, request, timeout \\ 5000)
                            else 
                                leaf=elem(list,1)
                                routing=elem(list,2)
                                thir=cut(fir,sec)
                                foc=fn(x)->
                                    cut(sec,x) 
                            end
                            #Project3.Worker.direction(uv, wx, foc, leaf, routing, imp, presentID, hops, list, yz)
                               direction(fir, sec, foc,leaf, routing, imp, presentID, hops, list, thir)
                            end
                        {:noreply,list}
                end
    end

    def leafNode(list) do
        linking=elem(list,2)
        s=length(Map.keys(linking))/2
        #Enum.take(enumerable, count)
        #Map.keys(map)
        temp= Enum.take(Map.keys(linking), s|> round)
        foc=fn(x)->
            {x , Map.get(linking,x)}  
            #Map.get(map, key, default \\ nil)
         end
        
         let(list,temp, foc, linking)
    end

    def direction(uv, wx, foc, leaf, routing, imp, presentID, hops, list, yz) do
        Enum.map(Map.values(leaf),foc)|>Enum.min_max
        if Enum.member?(Map.values(leaf),uv) do
            #Enum.member?(enumerable, element)
            f=fn(x)->
                {x,abs(cut(Map.get(leaf,x),wx)-yz)}
            end
           {k,v}= Enum.map(Map.keys(leaf),f)|>Enum.min_by(fn {k,v}->v end)
            GenServer.cast({Map.get(leaf,k)|>String.to_atom,node()},{:path,imp,presentID,Map.get(leaf,k)|>String.to_atom,hops+1})
        else
            f=fn(x)->
                loc= Map.get(routing,yz*4+x)
                if(loc != nil) do
                    
                    GenServer.cast({loc|>String.to_atom,node()},{:path,imp,presentID,loc|>String.to_atom,hops+1})
                    {1,yz*4+x}
                end
                {-1,1}
            end
            val=Enum.map(0..3, f) |> Map.new 

            p= Map.get(val,1)
            if p == nil do
                togther=Map.merge(leaf,routing)
                #Map.merge(map1, map2)
                
                f=fn(x)->
                    {x,Map.get(elem(list,0),x)|>Atom.to_string}
                end
                togther=Enum.map(Map.keys(elem(list,0)),f)|>Map.new|>Map.merge(togther)
                val=Enum.max_by(Map.values(togther),fn(x)->cut(uv,x)-yz end)
                #Enum.max_by(enumerable, fun, empty_fallback \\ fn -> raise(Enum.EmptyError) end)
                
                GenServer.cast({val|>String.to_atom,node()},{:path,imp,presentID,val|>String.to_atom,hops+1})
            end
        end 
    end

    def table(list,global,nextIdent) do
        #Project3.Worker.table(list, global, nextIdent)
        
        f=fn(x)->
            first=String.slice(global, 0, x)
            second=String.slice(nextIdent, 0, x)
            if(first==second) do
                second
            else
                ""
            end
        end

        subTable(list,global,nextIdent,f)
        Project3.Worker.subTable(list, global, nextIdent, f)

        
    end

    def let(list,temp,foc, linking) do
        node=Enum.map(Enum.take(temp,-2),foc) |>Map.new
        
          t=-1 *(length(Map.keys(linking))/2 |> round)
         tempory=Enum.take(Map.keys(linking), t)
        
          f=fn(x)->
            {x,Map.get(linking,x)}
          end
            node=Enum.map(Enum.take(tempory,2),f) |> Map.new |> Map.merge(node)
            list=Tuple.delete_at(list,1)|>Tuple.insert_at(1,node)
            list
    end

    

    def cut(i,j) do
        f=fn(x)->
            first=String.slice(i, 0, x)
            second=String.slice(j, 0, x)
            #String.slice(string, range)
            if(first==second) do
                second
            else
                ""
            end
        end
        check_val= Enum.map(0..(String.length(i)),f)
        final=Enum.max(check_val)|>String.length
        #Enum.max(enumerable, empty_fallback \\ fn -> raise(Enum.EmptyError) end)
        final
    end

    

    def subTable(list,global,nextIdent,f) do
        check_val= Enum.map(0..(String.length(global)),f)|>Enum.max
        routing=elem(list,2)
        if check_val != nil do
            create=String.at(nextIdent,String.length(check_val))
            #String.at(string, position)
            
            if create != nil do
               if create != global do 
                 if Map.get(routing,String.length(check_val)*4+String.to_integer(create)) == nil do
                    create=create|>String.to_integer
                        routing=Map.put(routing,(String.length(check_val))*4+create,nextIdent)
                        list=Tuple.delete_at(list,2)|>Tuple.insert_at(2,routing)
                        collection=elem(list,0)
                        f=fn(x)-> 
                            GenServer.cast({x,node()},{:combine,list,global,x,1})
                            GenServer.cast({global|>String.to_atom,node()},{:combine,list,x,global|>String.to_atom,1})
                        end
                        Enum.map(Map.values(collection),f)
                    end    
                end    
            end 
        end
        list
    end

  
end