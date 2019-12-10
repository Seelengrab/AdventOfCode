input = readline("input.1")

reaction = true

function search(input, reaction)
    prev = ''
        for i=1:length(input)
            charac = input[i]
        
            if(charac == uppercase(charac))
                if(prev == lowercase(charac))
                    input = replace(input, input[i-1:i] => "", count=1)
                    reaction = true
                    break
                end
            end
    
            if(charac == lowercase(charac))
                if(prev == uppercase(charac))
                    input = replace(input, input[i-1:i] => "", count=1)
                    reaction = true
                    break
                end
                
            end
    
            prev = charac
    
            if((i==length(input)))
                reaction = false
            end 
    
        end

        return input, reaction
end

function calc(input, reaction)
    while(reaction)

      input, reaction = search(input, reaction)
        
    end
    
    println(input)
    println(length(input))
end


#calc(input, reaction)
