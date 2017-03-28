

function targetForce = parse_TargetForce(arrayFiles)

    for n=1:size(arrayFiles.TargetForce)
        force(n,1)     = sscanf(arrayFiles.TargetForce{n}, '%g*');
        
        if ~isempty(strfind(arrayFiles.TargetForce{n},'%MVC'))
            forceType(n,1) = {'%MVC'};
        elseif ~isempty(strfind(arrayFiles.TargetForce{n},'Newtons'))
            forceType(n,1) = {'Newtons'};
        else 
            forceType(n,1) = {'Unrecognized'};
        end
    end
    
    targetForce = table(force,categorical(forceType),'VariableNames',{'Force','ForceType'});
    
end