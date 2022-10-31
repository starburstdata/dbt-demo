const csv = require('csv/sync');
const fs = require("fs");
const faker = require("@faker-js/faker");
const { v4: uuidv4 } = require('uuid');

const records = csv.parse(fs.readFileSync("../jaffle_webshop/raw_orders.csv"), {
  columns: true,
  skip_empty_lines: true
});

const uid_orderdate = {};

for (let i = 0; i < records.length; i++) {
  const record = records[i];
  if (uid_orderdate[record['user_id']] === undefined) {
    uid_orderdate[record['user_id']] = []
  }
  uid_orderdate[record['user_id']].push(new Date(record['order_date']));
}

const randomArrayEntry = (arr) => arr[Math.floor(Math.random() * arr.length)];
const randomDate = (start, end) => {
  return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
}
const randomNumber = (max) => Math.floor(Math.random() * max);

const randomCampaign = () => {
  while(true) {
    let num = randomNumber(5);
    if (num != 0) {
      return num;
    }
  }
}

const startDate = new Date(2018, 1, 1);
const endDate = new Date(2018, 4, 1);

const referrers = [
  "https://google.fr/",
  "https://search.google.be/",
  "https://app.facebook.com/",
  "https://facebook.com/",
  "https://google.com/",
  "https://instagram.com/",
  "https://youtube.com/",
  "https://pinterest.com?",
  "https://twitter.com/",
];

for (let i = 0; i < 10; i++) {
  referrers.push("https://" + faker.faker.internet.domainName() + "/");
}

const shopPages = [
  "https://jaffleshop.com",
  "https://jaffleshop.com/search",
  "https://jaffleshop.com/product/a",
  "https://jaffleshop.com/product/b",
  "https://jaffleshop.com/product/c",
  "https://jaffleshop.com/product/d",
  "https://jaffleshop.com/contact",
  "https://jaffleshop.com/returns",
]

const userAgents = [
  "Mozilla/5.0 (Linux; Android 12; SM-S906N Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/80.0.3987.119 Mobile Safari/537.36",
  "Mozilla/5.0 (iPhone14,3; U; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/19A346 Safari/602.1",
  "Mozilla/5.0 (iPhone13,2; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1",
  "Mozilla/5.0 (Linux; Android 7.0; Pixel C Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/52.0.2743.98 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246",
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36",
  "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1"
];

const languages = ["fr_FR", "it_IT", "de_DE", "en_US"];

const createRandomClick = (user, page, referrer, eventTime) => {
  return {
    visitorId: user.visitorId,
    userAgent: user.userAgent,
    language: user.language,
    event: "pageView",
    eventTime,
    page,
    referrer: referrer
  }
}

const simulateVisit = (user, date) => {
  const numClicks = randomNumber(20);
  let referrer = randomArrayEntry(referrers);
  if (randomNumber(1) == 0 ) {
    if (referrer.includes("facebook") || referrer.includes("instagram")) {
      referrer += "?utm_source=media&utm_medium=social&utm_campaign=" + randomCampaign();
    }
  }
  if (randomNumber(10) < 3) {
    referrer = ""
  }

  sessions.push({
    sessionId: user.visitorId,
    eventTime: new Date(date.getTime() + randomNumber(10) * 60 * 1000),
    user_id: (randomNumber(10) == 1 && user.id < 100) || user.orderDates.includes(date) ? user.id : undefined,
  })

  for (let i = 0; i < numClicks; i++) {
    let page = randomArrayEntry(shopPages);
    let eventTime = new Date(date.getTime() + randomNumber(30) * 60 * 1000);

    clicks.push(createRandomClick(user, page, referrer, eventTime));
    referrer = page;
    date = eventTime;
  }
  return clicks;
}

const createUsers = () => {
  const users = [];
  for (let i = 0; i < 200; i++) {
    const user = {
      id: i,
      visitorId: uuidv4(),
      language: randomArrayEntry(languages),
      userAgent: randomArrayEntry(userAgents),
      orderDates: uid_orderdate[i] || [],
    };
    user.orderDates.sort()
    users.push(user)
  }
  return users;
}
const users = createUsers();
let clicks = [];
const sessions = [];

for (let i = 0; i < 100; i++) {
  const user = users[i];
  const numVisits = randomNumber(5);

  const dates = [];
  for (let j = 0; j < numVisits; j++) {
    dates.push(randomDate(startDate, endDate));
  }
  dates.push(...user.orderDates);
  dates.sort();
  for (let j = 0; j < dates.length; j++) {
    simulateVisit(user, dates[j]);
  }
}

fs.writeFileSync("clicks.js", JSON.stringify(clicks, null, 2));
const sessionsCsv = csv.stringify(sessions)
fs.writeFileSync("sessions.csv", sessionsCsv);
