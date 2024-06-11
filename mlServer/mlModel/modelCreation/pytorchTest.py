import torch
import torch.nn as nn
import torch.optim as optim
import torchvision
import torchvision.transforms as transforms
from torchvision.datasets import ImageFolder
from torch.utils.data import DataLoader
from tqdm import tqdm

# Check if GPU is available
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

# Define transforms
transform = transforms.Compose([
    transforms.Resize((128, 128)),
    transforms.ToTensor(),
])

# Load datasets
training_set = ImageFolder('dataset/train', transform=transform)
validation_set = ImageFolder('dataset/valid', transform=transform)

# Define data loaders
train_loader = DataLoader(training_set, batch_size=32, shuffle=True)
val_loader = DataLoader(validation_set, batch_size=32, shuffle=True)

# Define CNN architecture
class CNN(nn.Module):
    def __init__(self):
        super(CNN, self).__init__()
        self.conv_layers = nn.Sequential(
            nn.Conv2d(3, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv2d(32, 32, kernel_size=3),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv2d(64, 64, kernel_size=3),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(64, 128, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv2d(128, 128, kernel_size=3),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(128, 256, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv2d(256, 256, kernel_size=3),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(256, 512, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv2d(512, 512, kernel_size=3),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Dropout(0.25)
        )
        # Adjust the input size of the first fully connected layer
        self.fc_layers = nn.Sequential(
            nn.Linear(512 * 2 * 2, 1500),  # Adjust input size based on output from conv layers
            nn.ReLU(),
            nn.Dropout(0.4),
            nn.Linear(1500, 38),
            nn.Softmax(dim=1)
        )

    def forward(self, x):
        x = self.conv_layers(x)
        x = x.view(x.size(0), -1)  # Flatten the output from conv layers
        x = self.fc_layers(x)
        return x

# Instantiate the model and move to GPU
cnn = CNN().to(device)

# Define loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(cnn.parameters(), lr=0.0001)

# Function to calculate accuracy
def get_accuracy(loader, model):
    correct = 0
    total = 0
    with torch.no_grad():
        for data in loader:
            inputs, labels = data[0].to(device), data[1].to(device)
            outputs = model(inputs)
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
    return correct / total

# Training the model
num_epochs = 10
for epoch in tqdm(range(num_epochs)):
    running_loss = 0.0
    for i, data in tqdm(enumerate(train_loader, 0)):
        inputs, labels = data[0].to(device), data[1].to(device)
        optimizer.zero_grad()
        outputs = cnn(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        running_loss += loss.item()
    
    # Print statistics
    # print('[%d, %5d] loss: %.3f' % (epoch + 1, i + 1, running_loss / len(train_loader)))
    # running_loss = 0.0

    # Save model after each epoch
    torch.save(cnn.state_dict(), 'trained_plant_disease_model_epoch_'+str(epoch)+'.pth')

# Evaluating the model
train_acc = get_accuracy(train_loader, cnn)
val_acc = get_accuracy(val_loader, cnn)
print('Training accuracy:', train_acc)
print('Validation accuracy:', val_acc)

# Saving the model
torch.save(cnn.state_dict(), 'trained_plant_disease_model.pth')
