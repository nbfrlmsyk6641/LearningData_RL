clc;clear;close;
define_original_agent
env_DDPG = rlSimulinkEnv("second_order_DDPG_change_obs","second_order_DDPG_change_obs/RL Agent");
% reinforcementLearningDesigner