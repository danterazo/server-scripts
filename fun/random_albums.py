import discogs_client
import pandas as pd

# setup session
dc = discogs_client.Client("DanteAlbumPicker/0.1")

# get user and inventory
user = dc.user("dd2814")
inventory = user.inventory

# list albums
print(inventory.count)

# TODO: work
# Format: Artist - Album (Year)

# print results
cds = ["The Ocean Blue - Beneath the Rhythm and Sound (1991)", "The Ocean Blue - Cerulean (1XXX)", "CD3"]
records = ["TOB - Record1", "TOB - Record2"]
cassettes = ["TOB - Cassette"]

# # print CDs
# print(f"CDs:")
# print(*cds, sep="\n")

# # print records
# print(f"\nRecords:\n")
# print(*records, sep="\n")

# # print cassettes
# print(f"\nCassettes:\n")
# print(*cassettes, sep="\n")

df = pd.DataFrame(list(zip(cds, records, cassettes)), columns=["CDs", "Records", "Vinyl"])

from IPython.display import display
from tabulate import tabulate
print(tabulate(df, headers = 'keys', tablefmt = 'psql'))
display(df)

# table_data = [
#     ['CDs', 'Vinyl', 'Cassette'],
#     ['The Ocean Blue - Beneath the Rhythm and Sound (1991)', 'b', 'c'], 
#     ['aaaaa', 'bbbbbbbbbb', 'c']
# ]

# for row in table_data:
#     print("{: >40} {: >40} {: >40}".format(*row))
