

% LOAD SUBJECT INFO
% LOAD TABLE

Subject_Information.SID = categorical(Subject_Information.SID);
Subject_Information.Status = categorical(Subject_Information.Status);
Subject_Information.Sex = categorical(Subject_Information.Sex);

Age = zeros(size(MU_Data,1),1);

SIDs = unique(MU_Data.SID);
for n=1:length(SIDs)
   ind = MU_Data.SID == SIDs(n);
   
   ind_2 = Subject_Information.SID == SIDs(n);
   AgeVec = Subject_Information.Age(ind_2);
   AgeVec = repmat(AgeVec,sum(ind),1);
   
   Age(ind) = AgeVec;
end

MU_Data.Age = Age;