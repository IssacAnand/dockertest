from django.db import models

# Create your models here.
# Name of Model -> Student (2 Fields name & Description Field)
class Student(models.Model):
    name=models.CharField(max_length=100)
    des=models.TextField()
    def __str__(self):
        return self.name
