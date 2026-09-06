# GymCoach.Api — multi-stage image for Render.com / local Docker
# Build context: backend/  (docker build -t gymcoach-api .)

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY GymCoach.sln ./
COPY src/GymCoach.Api/GymCoach.Api.csproj src/GymCoach.Api/
COPY src/GymCoach.Application/GymCoach.Application.csproj src/GymCoach.Application/
COPY src/GymCoach.Domain/GymCoach.Domain.csproj src/GymCoach.Domain/
COPY src/GymCoach.Infrastructure/GymCoach.Infrastructure.csproj src/GymCoach.Infrastructure/
COPY src/GymCoach.AI/GymCoach.AI.csproj src/GymCoach.AI/
COPY src/GymCoach.TrainingEngine/GymCoach.TrainingEngine.csproj src/GymCoach.TrainingEngine/

RUN dotnet restore src/GymCoach.Api/GymCoach.Api.csproj

COPY src/ src/
RUN dotnet publish src/GymCoach.Api/GymCoach.Api.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app

# Local Docker default; Render overrides PORT at runtime.
ENV ASPNETCORE_ENVIRONMENT=Production \
    PORT=8080 \
    Database__UseInMemory=true

COPY --from=build /app/publish .

EXPOSE 8080

# Program.cs binds http://0.0.0.0:${PORT} when PORT is set.
ENTRYPOINT ["dotnet", "GymCoach.Api.dll"]
