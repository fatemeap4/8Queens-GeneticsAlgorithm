clear;
clc;

populationSize = 100;
random_select = 5;
mutation_prob = 80;
GenerationRound = 500;
TotalRound = GenerationRound;
count = 5;

individual.Position = [];
individual.Fitness = [];
population = repmat (individual,populationSize,1);   % b tedade size miaym struct individual dorost mikonim 

for i = 1:populationSize
    population(i).Position = randperm(8);
end

for i = 1:populationSize
    population(i).Fitness = FindFitnessForChrom(population(i).Position);
end


% getTwo2 = TwoOfSelectionPop(population);
% recomb2 = cross_over(getTwo2);
% mutationChild2 = mutation(recomb2,mutation_prob);
% NewPopulation = ServiveSelect(population, mutationChild2)

%% Main Program
while GenerationRound > 0
    
   SelectedPop = SelectionPopulation(individual,population, count);   %select 5 chrom from population
   
   parents = TwoOfSelectionPop (SelectedPop);           %select 2 chrom from that 5 previous chrom
   
   childs = cross_over(parents);                    % produce 2 children
   
   childs = mutation(childs, mutation_prob);            % premute location of 2 index in chrom
   
   newPop = ServiveSelect(population, childs);              %new population in every round
   
   if childs(1).Fitness == 2
       done = 2;
   elseif childs(2).Fitness == 2
       done = 1;
   else 
       done = 0;    
   end
   
   if done == 2
       repeat = TotalRound - GenerationRound;
       fprintf("Yeeeeeeesss I found it after %d try and top 10 answer\n",repeat)
       numElem = numel(newPop);
       [~,sortOrder] = sort([newPop.Fitness]);
       NewPop = newPop(sortOrder);
       NewPop = NewPop(1:numElem);
       disp("In Done = 2");
       
       for i= length(NewPop):-1:(length(NewPop)-9)
           disp("Position:")
           disp(NewPop(i).Position(1:8));
           disp("Fitness:")
           disp(NewPop(i).Fitness);
           disp("------------------------------------------------");
       end
       disp("Best Answer:");
       disp(NewPop(end).Position(1:8));
       break;
   end
   
   if done == 1
       repeat = TotalRound - GenerationRound;
       fprintf("Yeeeeeeesss I found it after %d try and top 10 answer\n",repeat)
       numElem = numel(newPop);
       [~,sortOrder] = sort([newPop.Fitness]);
       NewPop = newPop(sortOrder);
       NewPop = NewPop(1:numElem);
       disp("In Done = 1");
       for i= length(NewPop):-1:(length(NewPop)-9)
           disp("Position:")
           disp(NewPop(i).Position(1:8));
           disp("Fitness:")
           disp(NewPop(i).Fitness);
           disp("------------------------------------------------");
       end
       disp("Best Answer:");
       disp(NewPop(end).Position(1:8));
       break;
   end
    GenerationRound= GenerationRound - 1;  
end

if GenerationRound <= 0
    numElem = numel(newPop);
    [~,sortOrder] = sort([newPop.Fitness]);
    NewPop = newPop(sortOrder);
    NewPop = NewPop(1:numElem);
    disp(" * * * * * * * * * * * * * * * * * * * * * * * * * * * * ");
    disp("*                                                       *");
    disp("*  I'm SORRYYYYY i can't Find a Chromosom had fitness=2 *");
    disp("*                                                       *");
    disp(" * * * * * * * * * * * * * * * * * * * * * * * * * * * * ");
    disp("");
    
    for i= length(NewPop):-1:(length(NewPop)-9)
        disp("Position:")
        disp(NewPop(i).Position(1:8));
        disp("Fitness:")
        disp(NewPop(i).Fitness);
        disp("------------------------------------------------");
    end
    
end

%% all Functions
function FindFit = FindFitnessForChrom(chrom)   % calculate Population Fitness
    threat = config_threat(chrom);
    if threat > 0
            FindFit = 1/threat;
    else
            FindFit = 2;
    end
end

function configuration_threat = config_threat(chrom) % calculate all Threats for a chrom
    sumation = 0;
    for i = 1: (length(chrom))
        sumation = sumation + eachQueenThreat(i, chrom);
    end
    configuration_threat = sumation;
    
end

function EachThreat = eachQueenThreat(index, chrom)     % calculate on queen Threats
    column = index;
    row = chrom(index);
    threats = 0;
    
    for i=1:(length(chrom))
        if i == column
            continue
        end
        
        if (chrom(i) < row ) && ( chrom(i) + abs((column-i)) == row)
            threats = threats+1;
        elseif (chrom(i) > row ) && ( chrom(i) - abs((column-i)) == row)
            threats = threats+1;
        end
        
        EachThreat = threats;
    end
end


function SelectPop = SelectionPopulation(individual,population, count)    % for more currency use least 5 parent
    randnum = randi([1,length(population)],1,count);
    selectedPop = repmat(individual,count,1);
    for j=1:count
        selectedPop(j).Position= population(randnum(j)).Position;
        selectedPop(j).Fitness= population(randnum(j)).Fitness;
    end
    SelectPop = selectedPop;
end


function GetParents= TwoOfSelectionPop (SelectedPop)
    numElem = numel(SelectedPop);
    [~,sortOrder] = sort([SelectedPop.Fitness]);
    parents = SelectedPop(sortOrder);
    parents = parents(1:numElem);
    GetParents = [parents(end-1); parents(end)];
end


function combine = cross_over(parents)
    Break = randi(6,1,1);
    childs = parents;
%     disp(Break);

    parent1 = parents(1).Position(:);
    parent1 = reshape(parent1,[1,8]);
    parent2 = parents(2).Position(:);
    parent2 = reshape(parent2,[1,8]);
    temp1(1:Break) = parent1(1:Break);
    temp2(1:Break) = parent2(1:Break);
    
    nextInd1 = Break+1;
    nextInd2 = Break+1;

    for i=1:8
        if parent1(i)~=temp2
            temp2(nextInd1) = parent1(i);
            nextInd1 = nextInd1 + 1;
        end
        if parent2(i)~= temp1
            temp1(nextInd2) = parent2(i);
            nextInd2 = nextInd2 + 1;
        end
    end
    childs(1).Position(:) = temp1;
    childs(2).Position(:) = temp2;
    combine = childs;
end

function mutationChild = mutation(childs, mutation_prob)
    mutated = childs; 
    counter = 1;
    
    for i =1: length(childs)
        probability = randi(100,1,1);
%         disp(probability);
        chrom = childs(i).Position;
%         disp(chrom);
        if probability < mutation_prob
            mutated(counter).Position = Mutate(chrom);
            counter = counter+1;
        else
            mutated(counter).Position= chrom;
            counter = counter+1;
        end
    end
    mutationChild = mutated;
end

function mutateChild = Mutate(child)
    RandPos1 = randi (7,1,1);
    RandPos2 = randi (7,1,1);
    temp = child(RandPos1);
    child(RandPos1) = child(RandPos2);
    child(RandPos2) = temp;
    
    mutateChild = child;
end


function NewPopulation = ServiveSelect(population, childs)
    numElem = numel(population);
    [~,sortOrder] = sort([population.Fitness]);
    population2 = population(sortOrder);
    population2 = population2(1:numElem);
    for i=1:length(childs)
        population2(i).Position = childs(i).Position;
        population2(i).Fitness = FindFitnessForChrom(childs(i).Position);
    end
    
    NewPopulation = population2;
end