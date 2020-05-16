import torch
import torch.nn as nn
import numpy as np
from torch.autograd import Variable 

class JointsMSELoss(nn.Module):
    def __init__(self, use_target_weight, vocab):
        super(JointsMSELoss, self).__init__()
        self.criterion = nn.MSELoss()
        self.use_target_weight = use_target_weight
        self.vocab = vocab

    def forward(self, outputs, targets):
        outputs_xyz = []
        targets_xyz = []
        for output, target in zip(outputs, targets):
            output_xyz = np.reshape([float(x) for x in self.vocab.poses[output-1].split(',')], (25,3))
            target_xyz = np.reshape([float(x) for x in self.vocab.poses[target-1].split(',')], (25,3))
            outputs_xyz.append(Variable(torch.Tensor(output_xyz), requires_grad=True))
            targets_xyz.append(Variable(torch.Tensor(target_xyz), requires_grad=True))
        
        loss = 0
        for output, target in zip(outputs_xyz, targets_xyz):
            for i in range(len(output)):
                loss += self.criterion(output[i], target[i])

        return loss / len(outputs)