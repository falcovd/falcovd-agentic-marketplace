import express from "express";
const app = express();
app.get("/v1/orders", (_req, res) => res.json({ data: [], error: null }));
app.listen(3000);
