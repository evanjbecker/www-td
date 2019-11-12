FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
EXPOSE 80
EXPOSE 443

WORKDIR /src
FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
COPY www-td/www-td.csproj src/www-td/
WORKDIR src/www-td
RUN dotnet restore "www-td.csproj"
COPY www-td/ .
COPY www-td.Database/ ../www-td.Database/
RUN dotnet build "www-td.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "www-td.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "www-td.dll"]