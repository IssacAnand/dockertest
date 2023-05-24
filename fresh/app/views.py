from django.shortcuts import render
# Getting db 
# from.models import Student

# Create your views here.

# Render index.html file
def index(request):
    # obj= Student.objects.all()
    # context = {
    #     "obj": obj,
    # }
    return render(request,"index.html")

    # return render(request,"index.html")