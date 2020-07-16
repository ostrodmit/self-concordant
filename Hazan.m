function [] = Hazan(allR)
for R = allR
    run_sims('Hazan','ones',2,R);
end
end