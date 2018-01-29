defmodule Project3 do
  use GenServer
  
 def main(args\\[]) do
    arguments=args
    numInput= length(arguments)

    if (numInput <2) do
      IO.puts "INVALID ARGUMENTS"
      :init.stop()
    end

    start_link(args)
    
    Process.sleep(1_000_000)
    #Process.sleep(timeout)
    #{:ok, pid} =
    #Task.start_link fn ->
     # ...
    #end
  
  #ref = Process.monitor(pid)
  #receive do
   # {:DOWN, ^ref, _, _, _} -> :task_is_down
  #after
   # 30_000 -> :timeout # Optional timeout
  #end
  end

  def init(args) do
    arguments=args
    numNodes=Enum.at(arguments,0)|> String.to_integer
    #Enum.at(enumerable, index, default \\ nil)
    numRequests= Enum.at(arguments,1)|> String.to_integer
    ll = fn(i)->

      initial=:crypto.hash(:sha,i|>Integer.to_string)
      initial=initial|>Base.encode16|>Convertat.from_base(16) |> Convertat.to_base(2)|>String.slice(0..127)
      val=initial|>Convertat.from_base(2)|>Convertat.to_base(4)|>String.to_atom

      map=Map.put(%{},i,val)
      #Map.put(map, key, value)
      
      Project3.Worker.start_link(Map.get(map,i))
      {i , Map.get(map,i)}
    end
    map= Map.new Enum.map(0..(numNodes-1),ll)
    for i<- 0..(numNodes-1) do
     for j <- Enum.take_random(0..(numNodes-1),2) do
      #Enum.take_random(enumerable, count)
        if i != j do
        GenServer.call({Map.get(map,i),node()},{:verify,Map.fetch(map,i),j,""},5000)
        GenServer.call({Map.get(map,j),node()},{:verify,Map.fetch(map,j),i,""},5000)
        #GenServer.call(server, request, timeout \\ 5000)
        end
      end
    end
    for i <-0..(numNodes-1) do
      GenServer.call({Map.get(map,i),node()},{:attach,Map.get(map,i),"",""},5000)
      GenServer.call({Map.get(map,i),node()},{:connect,"","",Map.get(map,i)},5000)
    end
    IO.puts "Sending message"
    for i<- 0..numRequests do
      for j<- 0..(numNodes-1) do
        random = :rand.uniform(numNodes)
        GenServer.cast({Map.get(map,i),node()},{:path,Map.get(map,random),:rand.uniform(100000),Map.get(map,j),0})
      end
    end
    {:ok,{map,numNodes,numRequests,%{}}}
  end
  
  
  def loop(map) do
    qq = fn(xxy)->
      GenServer.call({xxy,node()},{:connect,1,1,xxy})
    end
    Enum.map(Map.values(map),qq)
    #Enum.map(enumerable, fun)
    #Map.values(map)
    {:ok, pid} =
    Task.start_link fn ->
    
    end
  
  ref = Process.monitor(pid)
  #Process.monitor(item)
  receive do
    {:DOWN, ^ref, _, _, _} -> :task_is_down
  after
    30_000 -> :timeout # Optional timeout
  end
    loop(map)
  end

  def start_connection(application,server\\:error) do
    unless Node.alive?() do
      local_node_name = create_name(application,server)
      {:ok, _} = Node.start(local_node_name)
    end
    cookie = Application.get_env(application, :cookie)
    Node.set_cookie(cookie)
  end

  def create_name(application,server) do
    {:ok,record_ip}=:inet.getif()
   
    system = Application.get_env(application, :system, record_ip|>List.first|>Tuple.to_list|>List.first|>Tuple.to_list|>Enum.join("."))
    
    hex_value=
      case server do
      :error-> ""
      :ok->  :erlang.monotonic_time() |>
            :erlang.phash2(256) |>
            Integer.to_string(16)
      end
    String.to_atom("#{application}#{hex_value}@#{system}")
  end

  def handle_call({select,name,jumps},_from,condition) do
    cond do
     select== :substitute->
        path=for xxy <-1..condition-1 do
          #to lookup a server process, monitor it and send a cast to it:
          
          #process = GenServer.whereis(server)
          #monitor = Process.monitor(process)
          #GenServer.cast(process, :hello)
            if process = GenServer.whereis({rem((xxy+name),(condition))
            |>Integer.to_string|>String.to_atom,node()})!=nil do
                rem((xxy+name),(condition))
                 Process.monitor(process)
                GenServer.cast(process, :hello)
              end
            end
            
            
            
          |>MapSet.new|>MapSet.delete(nil)|>
          MapSet.to_list|>Enum.min_by(fn(xxy)->abs(xxy-name)end,fn->nil end)
          #Enum.min_by(enumerable, fun, empty_fallback \\ fn -> raise(Enum.EmptyError) end)
        {:reply,path,condition}
        select==  :server->
        maps=elem(condition,3)
        #Kernel.elem(tuple, index)
        IO.puts length(Map.values(maps))

        serverSide(maps,jumps,name,condition)

        select !=  :server and select != :substitute ->IO.puts "VALUES NOT DEFINED"
       {:reply,condition,condition};

    end
  end 

  
  def start_link(args) do
    GenServer.start_link(__MODULE__,args,name: :Server)
    #GenServer.start_link(module, args, options \\ [])
  end

  def serverSide(maps,jumps,name,condition) do
    if(length(Map.values(maps)) >= elem(condition,1)*elem(condition,2)*0.8) do
      IO.puts Enum.sum(Map.values(maps))/(Map.values(maps)|>length)
      mm = fn(xxy)->
        GenServer.stop({xxy|>Integer.to_string|>String.to_atom,node()})
        #GenServer.terminate({xxy|>Integer.to_string|>String.to_atom,node()})
        # GenServer.stop(server, reason \\ :normal, timeout \\ :infinity)
      end
      Enum.map(0..(elem(condition,1)-1),mm)
      
    else
        maps=Map.put_new(maps,name,jumps)
        #Map.put_new(map, key, value)
        condition=Tuple.delete_at(condition,3)|>
        Tuple.insert_at(3,maps)
        #Tuple.insert_at(tuple, index, value)
        #Tuple.delete_at(tuple, index)
    end
    {:reply,"",condition}
  
  end

end
