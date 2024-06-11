from fastapi import FastAPI,Depends 
from fastapi import Request, HTTPException,Header,status
from starlette.responses import Response
app = FastAPI()

@app.get('/healthCheck')
async def get(request:Request):
    return Response(status_code=status.HTTP_200_OK)

@app.get('/getModelOutput')
async def get(request:Request):
    try:
        pass
    except Exception as E:
        pass    
    pass